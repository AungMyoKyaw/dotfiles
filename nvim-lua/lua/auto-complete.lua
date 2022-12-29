local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver', 'rome', 'eslint', 'sumneko_lua', 'bashls', 'nimls', 'marksman'
})

lsp.setup()
