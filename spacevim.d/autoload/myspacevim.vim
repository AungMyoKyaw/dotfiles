func! myspacevim#before() abort
  " remap jj to esc
  inoremap jj <esc>
endf

func! myspacevim#after() abort
  " Folding
  nnoremap zO zA
  nnoremap zo za
  set      fdm=syntax
  set      nofoldenable
  
  " ctrlp config
  let g:ctrlp_match_window  = 'top,order:btt,min:1,max:20,results:20'
endf
