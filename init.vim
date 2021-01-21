set nocompatible

" Fish isn't sufficiently posixy for vim's use.
if &shell =~# 'fish$'
    set shell=sh
endif

set termguicolors
set background=light

call plug#begin('~/.local/share/nvim/plug')
source <sfile>:h/init/plugins.vim
source <sfile>:h/init/colours.vim
call plug#end()

colorscheme gruvbox

highlight! link Conceal Normal

" ~~~~~~~~~~~~~~
" ~~ SETTINGS ~~
" ~~~~~~~~~~~~~~

set mouse=a

set incsearch
set inccommand=nosplit
set nohlsearch
set noshowmode
set showcmd
set clipboard=unnamed
set updatetime=300

set formatoptions=croqj
set textwidth=80
set autoindent
set nojoinspaces

set list
set listchars=tab:↹·,nbsp:⎵,trail:·,extends:⇉,precedes:⇇
set showbreak=↪︎\
set fillchars=vert:│,fold:—
set foldminlines=4
set concealcursor=nc

set nowrap
set linebreak
set linespace=6

set scrolloff=2
set sidescrolloff=4
set sidescroll=1
set startofline

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround

set backspace=indent,eol,start
set virtualedit=block,onemore
set nostartofline
set allowrevins

set ignorecase
set smartcase
set gdefault

set splitbelow
set splitright
set equalalways
set switchbuf=useopen,usetab
set guioptions-=L
let no_buffers_menu = 0
set lazyredraw

set undofile
set undodir=~/.local/share/nvim/undo
set history=10000

set shortmess=fnxoOtTc
set signcolumn=yes
set wildchar=<Tab>
set wildmode=longest:full,full
set wildignore=*.o,*.hi,*/.git/*,*/dist-newstyle/*,*/.stack-work/*,*/node_modules/*,*/elm-stuff/*,*/serve/*

set noswapfile
set nobackup
set nowritebackup

" Remember info about open buffers on close -------------- "
set shada^=%
set hidden

set exrc
set secure

set diffopt=filler,vertical,context:4

let g:python3_host_prog = "/opt/local/bin/python3"

" Leader
let mapleader = ";"
let g:mapleader = ";"
let maplocalleader = "'"

" Return to last edit position when opening files -------- "
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

command! -nargs=+ Find execute 'silent grep! <args>'

augroup quickfix
    autocmd!

    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
    autocmd VimEnter        *     cwindow
augroup END

augroup vimrc
autocmd!

autocmd BufWinLeave * lclose
autocmd FileType html,vimwiki setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType text,markdown,pandoc,vimwiki     setlocal nonumber fo+=t tw=72
autocmd FileType text setlocal nospell
autocmd FileType markdown,pandoc call AR_autotoggle_list()
autocmd FileType gitcommit      setlocal textwidth=67
autocmd FileType qf     setlocal wrap linebreak
autocmd FileType haskell setlocal nofoldenable
autocmd FileType table setlocal tabstop=28 noexpandtab nolist

augroup END

function! AR_autotoggle_list()
    augroup list
        autocmd!
        autocmd InsertEnter <buffer=abuf> setlocal nolist
        autocmd InsertLeave <buffer=abuf> setlocal list
    augroup END
endfunction

let g:pandoc#syntax#conceal#blacklist = ['ellipses']
let g:pandoc#formatting#mode = 'h'
let g:pandoc#formatting#textwidth = 60
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 0
let g:pandoc#spell#enabled = 1

let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#label = 1

let g:clever_f_fix_key_direction = 1

set laststatus=2

let g:haddock_browser="/Applications/Safari.app/Contents/MacOS/Safari"

source <sfile>:h/init/vimwiki.vim
source <sfile>:h/init/mappings.vim
source <sfile>:h/init/ale.vim
source <sfile>:h/init/lightline.vim
source <sfile>:h/init/leaderf.vim
source <sfile>:h/init/coc.vim
