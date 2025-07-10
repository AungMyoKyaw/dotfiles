-- lua/plugins/pluginsettings.lua
local map = vim.keymap.set

-- Setup mini.nvim modules and integrations
local mini = {
  cursorword = require("mini.cursorword"),
  comment = require("mini.comment"),
  indentscope = require("mini.indentscope"),
  jump = require("mini.jump"),
  bufremove = require("mini.bufremove"),
  align = require("mini.align"),
  animate = require("mini.animate")
}

-- Configure the Catppuccin theme
local catppuccin = require("catppuccin")
catppuccin.setup({flavour = "mocha"})
vim.cmd.colorscheme "catppuccin"

-- Lualine statusline setup
local lualine = require("lualine")
lualine.setup({options = {theme = "catppuccin"}})

-- Gitsigns setup
local gitsigns = require("gitsigns")
gitsigns.setup()

-- Terminal integration
local toggleterm = require("toggleterm")
toggleterm.setup()
map("n", "<leader>ft", ":ToggleTerm<CR>", {noremap = true, silent = true})

-- Treesitter configuration
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
  auto_install = true,
  highlight = {enable = true, additional_vim_regex_highlighting = false}
})

-- FZF-Lua and Obsidian configuration
local fzf_lua = require("fzf-lua")
fzf_lua.setup({winopts = {preview = {hidden = "right:0"}}})

local personal_path = os.getenv("OBSIDIAN_PERSONAL_PATH")
if personal_path and personal_path ~= "" then
  local obsidian = require("obsidian")
  obsidian.setup({
    workspaces = {{name = "personal", path = vim.fn.expand(personal_path)}},
    picker = {name = "fzf-lua"},
    sort_by = "modified",
    open_notes_in = "vsplit",
    ui = {enable = false},
    note_id_func = function(title)
      local timestamp = tostring(os.time())
      if title then
        local slug = title:gsub("%s+", "-"):gsub("[^a-zA-Z0-9%-]", ""):lower()
        return timestamp .. "-" .. slug
      end
      return timestamp
    end
  })
  map("n", "<leader>ww", ":ObsidianQuickSwitch<CR>",
      {noremap = true, silent = true})
  map("n", "<leader>ws", ":ObsidianSearch<CR>", {noremap = true, silent = true})
end

map("n", "<leader>bb", fzf_lua.buffers, {noremap = true, silent = true})

-- Initialize all mini.nvim modules
for _, mod in pairs(mini) do mod.setup() end

-- Setup statusline and jump keymap
map("n", "<Leader><Leader>f", function() mini.jump.jump("f") end,
    {noremap = true, silent = true})

-- Fuzzy file finding
map("n", "<C-p>", ":FzfLua files<CR>", {noremap = true, silent = true})

-- Nvim-tree setup
local nvim_tree = require("nvim-tree")
nvim_tree.setup({renderer = {highlight_opened_files = "all"}})
map("n", "<C-n>", ":NvimTreeToggle<CR>", {noremap = true, silent = true})

-- Grug-Far integration
local grug_far = require("grug-far")
grug_far.setup({
  engines = {
    ripgrep = {path = "rg", extraArgs = "--hidden --glob !.git --ignore-case"}
  }
})
map({"n", "v"}, "<C-F>f", function()
  local mode, search_text = vim.fn.mode(), ""
  if mode == "v" then
    vim.cmd("normal! \"vy")
    search_text = vim.fn.getreg("v")
  else
    search_text =
        (vim.fn.expand("<cword>") ~= "" and vim.fn.expand("<cword>")) or
            vim.fn.getreg("/")
  end
  grug_far.open({default_text = search_text})
end, {
  noremap = true,
  silent = true,
  desc = "Open Grug-Far with selection or cursor word"
})

-- Buffer management with mini.bufremove
map("n", "<leader>bd", function() mini.bufremove.delete(0, true) end,
    {noremap = true, silent = true, desc = "Delete current buffer"})
map("n", "<leader>bw", function() mini.bufremove.wipeout(0, true) end,
    {noremap = true, silent = true, desc = "Wipeout current buffer"})

vim.api.nvim_create_user_command("BufOnly", function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      mini.bufremove.delete(buf, true)
    end
  end
end, {})

-- Command to reload configuration
map("n", "<leader>vr", function()
  vim.cmd("silent wa")
  dofile(vim.fn.stdpath("config") .. "/init.lua")
  print("Configuration reloaded!")
end, {noremap = true})

-- Which-key configuration
local which_key = require("which-key")
which_key.setup({
  plugins = {spelling = {enabled = true, suggestions = 20}},
  win = {border = "single"}
})

-- Auto Pair
local autopairs = require("nvim-autopairs")
autopairs.setup({})

-- nvim surround
local surround = require("nvim-surround")
surround.setup({})

-- devcontainer
local devcontainer = require("devcontainer")
devcontainer.setup({
  -- Optional: Customize container runtime (default: docker)
  container_runtime = "docker",
  -- Optional: Customize how Neovim is installed in the container
  nvim_installation_commands_provider = function(path_binaries, version_string)
    return {
      "apt-get update",
      "apt-get install -y neovim",
      "mkdir -p /home/vscode/.config/nvim",
      -- Optional: Copy local config to container (adjust path as needed)
      "cp -r /workspace/.nvim-config/* /home/vscode/.config/nvim/"
    }
  end,
  -- Optional: Specify workspace folder
  workspace_folder_provider = function() return vim.loop.cwd() end
})
