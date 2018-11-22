func! myspacevim#before() abort
  " remap jj to esc
  inoremap jj <esc>

  " Custom SPC mapping
  " ALEFIX
  call SpaceVim#custom#SPC('nnoremap', ['a', 'f'], ':ALEFix', 'ALEFIX', 1)
endf

func! myspacevim#after() abort
  " Folding
  nnoremap zO zA
  nnoremap zo za
  set      fdm=syntax
  set      nofoldenable
  
  " ctrlp config
  let g:ctrlp_match_window  = 'top,order:btt,min:1,max:20,results:20'

  " ALE Settings
  let g:ale_fixers                               = ['prettier']
  let g:ale_javascript_prettier_options          = '--single-quote --trailing-comma none'
  let g:ale_javascript_prettier_use_local_config = 1

  " Case insensitive commands
  set ignorecase
  set smartcase
endf
