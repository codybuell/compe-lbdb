if exists('g:loaded_compe_lbdb')
  finish
endif

let g:loaded_compe_lbdb = v:true

if exists('g:loaded_compe') && has('nvim')
  lua require('compe_lbdb')
endif
