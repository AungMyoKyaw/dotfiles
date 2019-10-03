func! myspacevim#before() abort
  " Custom SPC mapping
  " PRETTIER
  call SpaceVim#custom#SPC('nnoremap', ['a', 'p'], ':Prettier', 'PRETTIER', 1)

  " vimwiki
  let g:vimwiki_global_ext = 0
  let mywiki               = {}
  let mywiki.path          = '~/Dropbox/MyWiki/'
  let mywiki.syntax        = 'markdown'
  let mywiki.ext           = '.md'
  let g:vimwiki_list       = [mywiki]
  let g:vimwiki_folding    = 'expr'

  " disable some plugins
  let g:spacevim_disabled_plugins = ['vim-startify','gruvbox']

  " nvim python2 provider
  let g:python_host_prog = '/usr/local/bin/python2'
  " nvim python3 provider
  let g:python3_host_prog = '/usr/local/bin/python3'

  " disable ruby provider
  let g:loaded_ruby_provider   = 0
  " disable nodejs provider
  let g:loaded_node_provider   = 0

  " ctrlsf
  let g:ctrlsf_ackprg='rg'

  " vim polyglot settting
  let g:vim_markdown_conceal             = 0
  let g:vim_markdown_conceal_code_blocks = 0
  let g:javascript_plugin_jsdoc          = 1

  " ctrlsf
  nmap     <C-F>f <Plug>CtrlSFPrompt
  vmap     <C-F>f <Plug>CtrlSFVwordPath
  vmap     <C-F>F <Plug>CtrlSFVwordExec
  nmap     <C-F>n <Plug>CtrlSFCwordPath
  nmap     <C-F>p <Plug>CtrlSFPwordPath
  nnoremap <C-F>o :CtrlSFOpen<CR>
  nnoremap <C-F>t :CtrlSFToggle<CR>
  inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
endf

func! myspacevim#after() abort
  " remap jj to esc
  inoremap jj <esc>

  " disable mouse
  set mouse=

  " FOLDING
  nnoremap zO zA
  nnoremap zo za
  set      nofoldenable
  set foldlevel=0
  set fdm=indent

  " PRETTIER
  let g:prettier#config#single_quote = 'true'

  " CASE INSENSITIVE COMMANDS
  set ignorecase
  set smartcase

  " Cursor shape By Mode
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

  " enable tty fast
  set ttyfast

  " lazyredraw
  set lazyredraw
endf
