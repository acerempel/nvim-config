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

set incsearch inccommand=nosplit nohlsearch
set noshowmode showcmd
set clipboard=unnamed

set updatetime=300 timeoutlen=600

set formatoptions=croqj textwidth=80
set autoindent nojoinspaces

set list listchars=tab:↹·,nbsp:⎵,trail:·,extends:⇉,precedes:⇇
set showbreak=↪︎\ fillchars=vert:│,fold:—
set diffopt=filler,vertical,context:4
set nowrap linebreak breakindent

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
