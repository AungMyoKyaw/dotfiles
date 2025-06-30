-- lua/plugins/auto-complete.lua
vim.lsp.set_log_level("off")

local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- Initialize Mason
mason.setup()

mason_lspconfig.setup({
  ensure_installed = {
    "eslint",
    "bashls",
    "emmet_language_server",
    "vimls",
    "html",
    "cssls",
    "lua_ls",
    "tailwindcss",
    "biome"
  },
  automatic_installation = true
})

local function on_attach(_, bufnr) lsp_zero.default_keymaps({buffer = bufnr}) end

mason_lspconfig.setup({
  ensure_installed = {
    "eslint",
    "bashls",
    "emmet_language_server",
    "vimls",
    "html",
    "cssls",
    "lua_ls",
    "tailwindcss",
    "biome"
  },
  automatic_installation = true,
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = lsp_zero.get_capabilities()
      })
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
