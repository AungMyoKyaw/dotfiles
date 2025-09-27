-- Guard for treesitter extmarks: clamp end_line/end_col to valid buffer range
--
-- Improvements implemented:
--  - Safer clamping: clamp end_line to [0, line_count-1] and end_col to the line length
--  - Toggleable via `vim.g.treesitter_extmark_guard` (1 = enabled, 0 = disabled)
--  - Debugging via `vim.g.treesitter_extmark_guard_debug` (0/1)
--  - Exposed `M.enable()` / `M.disable()` to programmatically toggle behavior
--  - pcall-wrapped original API with throttled notifications to avoid spamming
--  - Lightweight: only queries line text when end_col clamping is necessary
--
-- Rationale:
-- Treesitter may compute extmarks that end just past the buffer (race during edits).
-- Calling nvim_buf_set_extmark with an out-of-range end_row causes an error.
-- This module defensively clamps extmark ranges only for the treesitter highlighter
-- namespace to avoid changing behavior for other plugins.
--
-- How to disable:
--   let g:treesitter_extmark_guard = 0
-- How to enable debug messages:
--   let g:treesitter_extmark_guard_debug = 1
--
-- Quick test recipe:
-- 1. Enable debug: `:let g:treesitter_extmark_guard_debug = 1`
-- 2. Open a file and perform edits that previously triggered "Invalid 'end_row'".
-- 3. Check `:messages` for any guard logs.
local api = vim.api
local M = {}

-- Configurable globals
vim.g.treesitter_extmark_guard = vim.g.treesitter_extmark_guard == nil and 1 or
                                     vim.g.treesitter_extmark_guard
vim.g.treesitter_extmark_guard_debug = vim.g.treesitter_extmark_guard_debug ==
                                           nil and 0 or
                                           vim.g.treesitter_extmark_guard_debug

-- Namespace used by treesitter highlighter in runtime
local TS_NS = api.nvim_create_namespace("nvim.treesitter.highlighter")

-- Save original function
local _buf_set_extmark = api.nvim_buf_set_extmark

-- Throttled notifications state per-buffer
local notify_state = setmetatable({}, {__mode = "k"}) -- weak-keyed by bufnr
local MAX_NOTIF_PER_BUF = 3

local function should_notify(bufnr)
  local s = notify_state[bufnr]
  if not s then
    s = {count = 0}
    notify_state[bufnr] = s
  end
  if s.count < MAX_NOTIF_PER_BUF then
    s.count = s.count + 1
    return true
  end
  return false
end

-- Helper to safely clamp end_line/end_col
local function clamp_extmark_args(bufnr, opts)
  if type(opts) ~= "table" then return opts end

  -- If guard is disabled, do nothing
  if vim.g.treesitter_extmark_guard == 0 then return opts end

  -- If no explicit end_line/end_col provided, nothing to clamp
  if opts.end_line == nil and opts.end_col == nil then return opts end

  -- Only clamp for the treesitter highlighter namespace
  local ns = opts.ns or TS_NS
  if ns ~= TS_NS then return opts end

  -- Validate buffer
  if not api.nvim_buf_is_valid(bufnr) then return opts end

  local line_count = api.nvim_buf_line_count(bufnr)
  if line_count == 0 then return opts end

  local end_line = opts.end_line
  local end_col = opts.end_col

  -- If end_line is nil but end_col is set, assume same line as mark
  if end_line == nil then return opts end

  -- Clamp end_line to [0, line_count - 1]
  if end_line < 0 then
    if vim.g.treesitter_extmark_guard_debug == 1 and should_notify(bufnr) then
      vim.notify(string.format(
                     "treesitter_extmark_guard: clamping negative end_line %d -> 0 for buffer %d",
                     end_line, bufnr), vim.log.levels.WARN)
    end
    opts.end_line = 0
  elseif end_line >= line_count then
    if vim.g.treesitter_extmark_guard_debug == 1 and should_notify(bufnr) then
      vim.notify(string.format(
                     "treesitter_extmark_guard: clamping end_line %d -> %d (last line) for buffer %d",
                     end_line, line_count - 1, bufnr), vim.log.levels.WARN)
    end
    opts.end_line = line_count - 1
  end

  -- If end_col needs clamping, fetch the line text (only when necessary)
  if opts.end_col ~= nil then
    local target_line = opts.end_line
    local ok, line = pcall(api.nvim_buf_get_lines, bufnr, target_line,
                           target_line + 1, true)
    local line_text = ""
    if ok and type(line) == "table" and line[1] then line_text = line[1] end
    local max_col = #line_text

    if opts.end_col < 0 then
      if vim.g.treesitter_extmark_guard_debug == 1 and should_notify(bufnr) then
        vim.notify(string.format(
                       "treesitter_extmark_guard: clamping negative end_col %d -> 0 for buffer %d",
                       opts.end_col, bufnr), vim.log.levels.WARN)
      end
      opts.end_col = 0
    elseif opts.end_col > max_col then
      if vim.g.treesitter_extmark_guard_debug == 1 and should_notify(bufnr) then
        vim.notify(string.format(
                       "treesitter_extmark_guard: clamping end_col %d -> %d for buffer %d, line_len=%d",
                       opts.end_col, max_col, bufnr, max_col),
                   vim.log.levels.WARN)
      end
      opts.end_col = max_col
    end
  end

  return opts
end

-- Safe wrapper that pcall's the original API and logs on failure (throttled)
local function safe_buf_set_extmark(bufnr, ns, row, col, opts)
  local ok, res = pcall(_buf_set_extmark, bufnr, ns, row, col, opts)
  if not ok then
    if vim.g.treesitter_extmark_guard_debug == 1 and should_notify(bufnr) then
      vim.notify(string.format(
                     "treesitter_extmark_guard: protected call failed for bufnr=%d ns=%s err=%s",
                     bufnr, tostring(ns), tostring(res)), vim.log.levels.ERROR)
    end
    -- swallow the error to avoid breaking the caller; return nil to indicate failure
    return nil
  end
  return res
end

-- Runtime toggle state
local enabled = true

function M.enable()
  enabled = true
  vim.g.treesitter_extmark_guard = 1
end

function M.disable()
  enabled = false
  vim.g.treesitter_extmark_guard = 0
end

-- Override
api.nvim_buf_set_extmark = function(bufnr, ns, row, col, opts)
  -- If called with 5 args, shift parameters into opts if necessary
  if opts == nil and type(col) == "table" then
    opts = col
    col = opts and opts.start_col
  end

  opts = opts or {}
  -- Ensure namespace is present in opts for our check
  opts.ns = ns

  -- If disabled, just call original
  if not enabled or vim.g.treesitter_extmark_guard == 0 then
    opts.ns = nil
    return safe_buf_set_extmark(bufnr, ns, row, col, opts)
  end

  local safe_opts = clamp_extmark_args(bufnr, opts)
  -- Drop our ns field to avoid API confusion
  safe_opts.ns = nil

  return safe_buf_set_extmark(bufnr, ns, row, col, safe_opts)
end

-- Expose module for manual control if desired
return M
