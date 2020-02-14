let g:deoplete#enable_at_startup = 1

set completeopt=noinsert,menuone,noselect

call deoplete#custom#option('auto_complete', v:false)

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#manual_complete()

inoremap <silent><expr> <S-TAB>
    \ pumvisible() ? "\<C-p>" : \<S-TAB>

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

call deoplete#custom#option('candidate_marks',
      \ ['a', 's', 'd', 'f', 'g', 'h'])

inoremap <expr> <C-a>       pumvisible() ?
\ deoplete#insert_candidate(0) : ''
inoremap <expr> <C-s>       pumvisible() ?
\ deoplete#insert_candidate(1) : ''
inoremap <expr> <C-d>       pumvisible() ?
\ deoplete#insert_candidate(2) : ''
inoremap <expr> <C-f>       pumvisible() ?
\ deoplete#insert_candidate(3) : ''
inoremap <expr> <C-g>       pumvisible() ?
\ deoplete#insert_candidate(4) : ''
inoremap <expr> <C-h>       pumvisible() ?
\ deoplete#insert_candidate(5) : ''
inoremap <expr> /       pumvisible() ?
\ deoplete#complete_common_string() : '/'

inoremap <silent><expr> <CR> pumvisible() ? deoplete#close_popup() : "\<CR>"

call deoplete#custom#source('_', 'matchers', ['matcher_length', 'matcher_fuzzy'])
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

call deoplete#custom#option('sources', {
  \ '_': ['buffer', 'files'],
  \ 'haskell': ['ale'],
  \ })

call deoplete#enable_logging('DEBUG', '/Users/alan/.local/share/nvim/deoplete.log')

