" ~~~~~~~~~~~~~~
" ~~ MAPPINGS ~~
" ~~~~~~~~~~~~~~

inoremap ;; <Esc>
inoremap zz <Esc>

map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

noremap Q @@
nnoremap ; :

imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" Make Y editor command consistent with D, C, etc.
noremap Y y$

" Leader
let mapleader = " "
let g:mapleader = " "
let maplocalleader = "'"

noremap <silent> <Space> <Nop>

map <leader>B :BufExplorer<CR>

nnoremap <silent> U :UndotreeToggle<CR>

nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
noremap <silent> <D-t> :tabnew<CR>

augroup pandoc
  au!
  au FileType pandoc call PandocMappings()
augroup END

function! PandocMappings()
  nmap <buffer> <Leader>nn <Plug>AddVimFootnote
  nmap <buffer> <Leader>ne <Plug>EditVimFootnote
  nmap <buffer> <Leader>nr <Plug>ReturnFromFootnote
  imap <buffer> <C-f> <Plug>AddVimFootnote
endfunction
