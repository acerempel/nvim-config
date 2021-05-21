" Lightline

if !exists("g:lightline")
  let g:lightline = {}
endif

let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ],
    \           [ 'filename', 'readonly', 'modified' ],
    \           [ 'gitbranch', 'gitdiff' ] ],
    \ 'right': [ [ 'percent', 'lineinfo' ],
    \            [ 'filetype', 'fileformat' ],
    \            [ 'lspstatus' ] ]
    \ }

let g:lightline.inactive = {
    \ 'left': [ [ 'filename', 'readonly', 'modified' ], [ 'gitdiff' ] ],
    \ 'right': [ [ 'percent' ],
    \            [ 'filetype', 'fileformat' ] ]
    \ }

let g:lightline.component = {
    \ 'modified': '[%M]',
    \ 'readonly': '[%R]'
    \ }

let g:lightline.component_function = {
    \ 'gitbranch': 'AR_git_branch',
    \ 'fileformat': 'AR_fileformat',
    \ 'gitdiff': 'AR_gitgutter_status',
    \ 'lspstatus': 'AR_lsp_status'
    \ }

let g:lightline.component_function_visible_condition = {
    \ 'gitdiff': 'exists("b:gitsigns_head")',
    \ 'gitbranch': 'exists("b:gitsigns_head")',
    \ 'fileformat': '&ff != "unix"',
    \ 'lspstatus': 'luaeval("not vim.tbl_isempty(vim.lsp.buf_get_clients(0))")'
    \ }

let g:lightline.subseparator = { 'left': '', 'right': '' }

function! AR_git_branch()
  return get(b:, 'gitsigns_head', '')
endfunction

function! AR_gitgutter_status()
  return get(b:, 'gitsigns_status', '')
endfunction

function! AR_fileformat()
    return &ff == "unix" ? "" : &ff
endfunction

function! AR_lsp_status()
  if luaeval("not vim.tbl_isempty(vim.lsp.buf_get_clients(0))")
    let l:status = 'E:'
    let l:status .= luaeval("vim.lsp.diagnostic.get_count(0, 'Error')")
    let l:status .= ' W:'
    let l:status .= luaeval("vim.lsp.diagnostic.get_count(0, 'Warning')")
    return l:status
  else
    return ''
  endif
endfunction
