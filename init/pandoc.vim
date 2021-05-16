let g:pandoc#syntax#conceal#blacklist = ['ellipses']
let g:pandoc#formatting#mode = 'h'
let g:pandoc#formatting#textwidth = 60
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 0
let g:pandoc#spell#enabled = 1

function! ZoteroCite()
  " pick a format based on the filetype (customize at will)
  let format = &filetype =~ '.*tex' ? 'citep' : 'pandoc'
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format.'&brackets=1'
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

noremap <leader>z "=ZoteroCite()<CR>p
inoremap <C-z> <C-r>=ZoteroCite()<CR>
