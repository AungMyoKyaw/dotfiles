-- lua/plugins/auto-complete.lua
-- Compatibility: prefer the new vim.lsp.log.set_level API, fall back to vim.lsp.set_log_level
do
  if vim.lsp and vim.lsp.log and type(vim.lsp.log.set_level) == "function" then
    -- use the new API
    vim.lsp.log.set_level("OFF")
  elseif vim.lsp and type(vim.lsp.set_log_level) == "function" then
    -- fallback for older Neovim versions
    pcall(vim.lsp.set_log_level, "off")
  end
end

local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Initialize Mason
mason.setup()

local function on_attach(_, bufnr) lsp_zero.default_keymaps({buffer = bufnr}) end

mason_lspconfig.setup({
  ensure_installed = {
    "swift",
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "javascript",
    "typescript",
    "html",
    "css",
    "json",
    "markdown"
  },
  automatic_installation = true,
  handlers = {
    function(server_name)
      vim.lsp.config(server_name, {
        on_attach = on_attach,
        capabilities = lsp_zero.get_capabilities()
      })
      vim.lsp.enable(server_name)
    end
  }
})

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({select = false})
  }),
  sources = cmp.config.sources({
    {name = "nvim_lsp"},
    {name = "path"},
    {name = "buffer"}
  })
})
