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
  let g:spacevim_disabled_plugins = ['vim-startify']

  " ctrlsf
  let g:ctrlsf_ackprg='rg'

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
  set foldlevel=1
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

  " limit syntax hightlight
   augroup vimrc
     autocmd!
     autocmd BufWinEnter,Syntax * syn sync minlines=500 maxlines=500
   augroup END
endf
