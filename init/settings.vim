" Fish isn't sufficiently posixy for vim's use.
if &shell =~# 'fish$'
    set shell=sh
endif

set termguicolors
set background=light

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
set wildignore=*.o,*.hi,*/.git/*,*/dist-newstyle/*,*/.stack-work/*,*/node_modules/*,*/elm-stuff/*

set noswapfile
set nobackup
set nowritebackup

" Remember info about open buffers on close -------------- "
set shada^=%
set hidden

set exrc
set secure

set diffopt=filler,vertical,context:4

" Leader
let mapleader = " "
let g:mapleader = " "
let maplocalleader = "'"

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

command! -nargs=+ Find execute 'silent grep! <args>'
