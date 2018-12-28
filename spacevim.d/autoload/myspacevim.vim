func! myspacevim#before() abort
  " remap jj to esc
  inoremap jj <esc>

  " disable mouse
  set mouse=

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

  " Cursor shape By Mode
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

endf

func! myspacevim#after() abort
  " FOLDING
  nnoremap zO zA
  nnoremap zo za
  set      fdm=syntax
  set      nofoldenable

  " CTRLP
  let g:ctrlp_match_window  = 'top,order:btt,min:1,max:20,results:20'

  " PRETTIER
  let g:prettier#config#single_quote = 'true'

  " CASE INSENSITIVE COMMANDS
  set ignorecase
  set smartcase
endf
