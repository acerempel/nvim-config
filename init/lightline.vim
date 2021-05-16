" Lightline

if !exists("g:lightline")
  let g:lightline = {}
endif

let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ],
    \           [ 'gitbranch', 'filename', 'readonly', 'gitdiff', 'modified' ] ],
    \ 'right': [ [ 'alestatus', 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'filetype' ],
    \            [ 'vm_modes' ] ]
    \ }

let g:lightline.inactive = {
    \ 'left': [ [ 'filename', 'readonly', 'gitdiff', 'modified' ] ],
    \ 'right': [ [ 'percent' ],
    \            [ 'fileformat', 'filetype' ] ]
    \ }

let g:lightline.component = {
    \ 'modified': '[%M]',
    \ 'readonly': '[%R]'
    \ }

let g:lightline.component_function = {
    \ 'gitbranch': 'AR_git_branch',
    \ 'fileformat': 'AR_fileformat',
    \ 'gitdiff': 'AR_gitgutter_status',
    \ 'alestatus': 'AR_ale_status'
    \ }

let g:lightline.component_function_visible_condition = {
    \ 'gitbranch': 'fugitive#head() != ""',
    \ 'fileformat': '&ff != "unix"',
    \ 'gitdiff': 'gitgutter#utility#is_active()'
    \ }

let g:lightline.subseparator = { 'left': '', 'right': '' }

function! AR_git_branch()
    if has('nvim-0.5')
      return
    endif
    return fugitive#head() != '' ? "(" . fugitive#head() . ")" : ''
endfunction

function! AR_gitgutter_status()
  return get(b:, 'coc_git_status', '')
endfunction

function! AR_fileformat()
    return &ff == "unix" ? "" : &ff
endfunction

function! AR_ale_status()
  if !has('nvim-0.5')
    let ale_status = ale#statusline#Count(bufnr("%"))
    let notices = []
    if ale_status.error > 0
        call add(notices, "E:" . ale_status.error)
    endif
    if ale_status.warning > 0
        call add(notices, "W:" . ale_status.warning)
    endif
    if ale_status.info > 0
        call add(notices, "I:" . ale_status.info)
    endif
    return join(notices)
  endif
endfunction
