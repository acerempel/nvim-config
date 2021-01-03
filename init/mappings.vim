" ~~~~~~~~~~~~~~
" ~~ MAPPINGS ~~
" ~~~~~~~~~~~~~~

imap ;; <Esc>

map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

noremap Q @@
nnoremap <space> :

imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" Make Y editor command consistent with D, C, etc.
noremap Y y$

map <leader>B :BufExplorer<CR>

nnoremap <silent> U :UndotreeToggle<CR>

nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
noremap <silent> <D-t> :tabnew<CR>
