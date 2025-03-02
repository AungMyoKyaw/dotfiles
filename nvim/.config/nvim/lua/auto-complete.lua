local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')

-- Initialize Mason (LSP server manager)
mason.setup()

mason_lspconfig.setup({
  ensure_installed = {
    'eslint',
    'bashls',
    'emmet_language_server',
    'vimls',
    'html',
    'cssls',
    'lua_ls',
    'tailwindcss',
    'biome'
  },
  automatic_installation = true
})

-- Function to run on LSP attachment
local function on_attach(_, bufnr) lsp_zero.default_keymaps({buffer = bufnr}) end

-- Configure LSP servers dynamically with Mason
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = lsp_zero.get_capabilities()
    })
  end
})

-- Setup Autocompletion with nvim-cmp
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}) -- Confirm selection
    -- Uncomment for tab-based navigation
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    {name = 'nvim_lsp'}, -- LSP completions
    {name = 'path'}, -- File path completions
    {name = 'buffer'} -- Buffer word completions
  })
})
