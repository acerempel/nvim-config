let g:deoplete#enable_at_startup = 1

set completeopt=noinsert,menuone,noselect

call deoplete#custom#option('auto_complete', v:false)

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#manual_complete()

inoremap <silent><expr> <S-TAB>
    \ pumvisible() ? "\<C-p>" : "\<S-TAB>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

call deoplete#custom#option('candidate_marks',
      \ ['h', 'j', 'k', 'l'])

inoremap <expr> <C-h>       pumvisible() ?
\ deoplete#insert_candidate(0) : ''
inoremap <expr> <C-j>       pumvisible() ?
\ deoplete#insert_candidate(1) : ''
inoremap <expr> <C-k>       pumvisible() ?
\ deoplete#insert_candidate(2) : ''
inoremap <expr> <C-l>       pumvisible() ?
\ deoplete#insert_candidate(3) : ''
inoremap <expr> /       pumvisible() ?
\ deoplete#complete_common_string() : '/'

inoremap <silent><expr> <CR> pumvisible() ? deoplete#close_popup() : "\<CR>"

call deoplete#custom#source('_', 'matchers', ['matcher_length', 'matcher_fuzzy'])
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

call deoplete#enable_logging('DEBUG', '/Users/alan/.local/share/nvim/deoplete.log')
