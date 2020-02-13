" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~ alealealealealealealealealealealeale ~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = { 'haskell': ['hlint', 'ghc-ide'], 'php': [] }

" Returns the directory containing the filename of the referenced buffer.
function! s:get_buffer_directory(buffer_number) abort
  return fnamemodify(bufname((a:buffer_number)), ":h")
endfunction

call ale#linter#Define('haskell', {
  \ 'name': 'ghc-ide',
  \ 'lsp': 'stdio',
  \ 'executable': '/Users/alan/.local/bin/ghcide',
  \ 'command': '%e --lsp',
  \ 'project_root': funcref("s:get_buffer_directory"),
  \ })

map <Leader>ad :ALEDetail<CR>
map <Leader>ai :ALEInfo<CR>
map <silent> [w :ALEPreviousWrap<CR>
map <silent> ]w :ALENextWrap<CR>

augroup ale_haskell
  au!
  au FileType haskell nnoremap <silent> K :ALEHover<CR>
  au FileType haskell nnoremap <silent> gd :ALEGoToDefinition<CR>
augroup END

