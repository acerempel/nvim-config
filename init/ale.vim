" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~ alealealealealealealealealealealeale ~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = { 'haskell': ['ghc-ide'], 'php': [], 'rust': ['analyzer'] }

function! s:get_ghcide_root_directory(buffer_number) abort
  let l:bufinfo = getbufinfo(a:buffer_number)[0]
  let l:dir = fnamemodify(l:bufinfo.name, ":h")
  return l:dir
endfunction

function! s:get_hie_root_directory(buffer_number) abort
  let l:bufinfo = getbufinfo(a:buffer_number)[0]
  let l:bufdir = fnamemodify(l:bufinfo.name, ":h")
  let l:dir = l:bufdir
  let l:home = expand("~")
  while l:dir != l:home
    if filereadable(l:dir . "/hie.yaml")
      return l:dir
    elseif filereadable(l:dir . "/cabal.project")
      return l:dir
    else
      let l:dir = fnamemodify(l:dir, ":h")
    endif
  endwhile
  if l:dir == l:home
    return l:bufdir
  else
    return l:dir
  endif
endfunction

call ale#linter#Define('haskell', {
  \ 'name': 'ghc-ide',
  \ 'lsp': 'stdio',
  \ 'executable': '/Users/alan/.local/bin/ghcide',
  \ 'command': '%e --lsp',
  \ 'project_root': funcref("s:get_hie_root_directory"),
  \ })

call ale#linter#Define('python', {
  \ 'name': 'python-language-server',
  \ 'lsp': 'stdio',
  \ 'executable': '/Users/alan/Library/Python/3.8/bin/pyls',
  \ 'command': '%e --log-file /Users/alan/.local/share/pyls/pyls-nvim.log',
  \ 'project_root': funcref("s:get_ghcide_root_directory"),
  \ })

map <silent> <Leader>ad :ALEDetail<CR>
map <silent> <Leader>ai :ALEInfo<CR>
map <silent> [w :ALEPreviousWrap<CR>
map <silent> ]w :ALENextWrap<CR>

augroup ale_haskell
  au!
  au FileType haskell,rust nnoremap <silent> K :ALEHover<CR>
  au FileType haskell,rust nnoremap <silent> gd :ALEGoToDefinition<CR>
augroup END
