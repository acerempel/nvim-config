au User lsp_setup call lsp#register_server({
  \ 'name': 'ghcide',
  \ 'cmd': {server_info->['ghcide','--lsp']},
  \ 'whitelist': ['haskell'],
  \ })

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.local/share/nvim/vim-lsp.log')

function! s:configure_for_lsp() abort
  setlocal signcolumn=yes
  nmap K <plug>(lsp-document-hover)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:configure_for_lsp()
augroup END
