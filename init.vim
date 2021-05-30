if !has('nvim-0.5')
  echoerr "Neovim too old!!"
  exit
endif

" OPTIONS {{{

" Fish isn't sufficiently posixy for vim's use.
if &shell =~# 'fish$'
    set shell=sh
endif

" ~~~~~~~~~~~~~~
" ~~ SETTINGS ~~
" ~~~~~~~~~~~~~~

set mouse=a

set incsearch inccommand=nosplit nohlsearch
set noshowmode showcmd
set clipboard=unnamed

set updatetime=300 timeoutlen=700

set formatoptions=croqj textwidth=80
set autoindent nojoinspaces

set list listchars=tab:↹·,nbsp:⎵,trail:·,extends:⇉,precedes:⇇
set showbreak=↪︎
set fillchars=vert:│,fold:—
set diffopt=filler,vertical,context:4
set nowrap linebreak breakindent
set foldlevelstart=2

set linespace=6
set foldminlines=4
set concealcursor=nc

set scrolloff=2 sidescrolloff=4 sidescroll=1
set startofline

set expandtab tabstop=2 softtabstop=2
set shiftwidth=2 shiftround

set backspace=indent,eol,start
set virtualedit=block,onemore
set nostartofline allowrevins

set ignorecase smartcase gdefault

set splitbelow splitright equalalways
set switchbuf=useopen,usetab
set guioptions-=L
let no_buffers_menu = 0
set lazyredraw

set undofile undodir=~/.local/share/nvim/undo
set noswapfile nobackup nowritebackup
set history=10000

set shortmess=fnxoOtTc
set signcolumn=yes

set wildchar=<Tab>
set wildmode=longest:full,full
set wildignore=*.o,*.hi,*/.git/*,*/dist-newstyle/*,*/.stack-work/*,*/node_modules/*,*/elm-stuff/*

" Remember info about open buffers on close -------------- "
set shada^=% hidden

set exrc secure

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

command! -nargs=+ Find execute 'silent grep! <args>'

" }}}

" COLOURS {{{
set termguicolors
source <sfile>:h/init/colours_gruvbox.vim
highlight! link Conceal Normal
" }}}

" AUTOCOMMANDS {{{

" Return to last edit position when opening files -------- "
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

augroup packer
  autocmd!
  " Automatically enable changes to plugin configuration
  autocmd BufWritePost plugins.lua PackerCompile
augroup END

augroup terminal
  au!
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
augroup END

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

augroup filetypes
  autocmd!
  autocmd FileType html,vimwiki setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType prose,vimwiki     setlocal nonumber fo+=t tw=72
  autocmd FileType markdown setlocal nospell
  autocmd FileType prose setlocal spell
  autocmd FileType gitcommit      setlocal textwidth=67
  autocmd FileType qf     setlocal wrap linebreak
  autocmd FileType table setlocal tabstop=28 noexpandtab nolist
  autocmd FileType cabal au BufWritePre <buffer=abuf> %!cabal-fmt
  autocmd BufReadPost,BufNew *.wiki ++once packadd vimwiki
augroup END

function! SetTreeSitterFolding() abort
  setlocal foldenable
  setlocal foldmethod=expr
  setlocal foldexpr=nvim_treesitter#foldexpr()
endfunction

augroup treesitter
  au!
  au FileType rust,javascript,typescript,javascriptreact,typescriptreact,lua,nix,php,html,css call SetTreeSitterFolding()
augroup END

" }}}

lua << ENDLUA
  require('plugins')
  require('lsp')
  require('completion')
  require('mappings')
ENDLUA

" MAPPINGS {{{

" Leaders {{{
let mapleader = " "
let g:mapleader = " "
let maplocalleader = "'"

noremap <silent> <Space> <Nop>
" }}}

" Moving around {{{
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

noremap Q @@
nnoremap ; :

nnoremap <silent> U <Cmd>UndotreeToggle<CR>

imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" Make Y editor command consistent with D, C, etc.
noremap Y y$

nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
noremap <silent> <D-t> :tabnew<CR>
" }}}

" Pandoc {{{
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
" }}}

" Telescope {{{
cmap <C-R> <Plug>(TelescopeFuzzyCommandSearch)
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>
" }}}

" }}}

source <sfile>:h/init/pandoc.vim
source <sfile>:h/init/vimwiki.vim
source <sfile>:h/init/misc_plugin_settings.vim

" vim:foldmethod=marker:foldenable
