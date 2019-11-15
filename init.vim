set nocompatible

" Fish isn't sufficiently posixy for vim's use.
if &shell =~# 'fish$'
    set shell=sh
endif

call plug#begin('~/.local/share/nvim/plug')
Plug 'https://github.com/w0rp/ale'
Plug 'https://github.com/jiangmiao/auto-pairs'
Plug 'https://github.com/sjl/badwolf'
Plug 'https://github.com/jlanzarotta/bufexplorer'
Plug 'https://github.com/vmchale/cabal-project-vim'
Plug 'https://github.com/rhysd/clever-f.vim'
Plug 'https://github.com/yuttie/comfortable-motion.vim'
Plug 'https://github.com/rhysd/committia.vim'
Plug 'https://github.com/konfekt/fastfold'
Plug 'https://github.com/junegunn/gv.vim'
Plug 'https://github.com/othree/html5.vim'
Plug 'https://github.com/michaeljsmith/vim-indent-object'
Plug 'https://github.com/hecal3/vim-leader-guide'
Plug 'https://github.com/itchyny/lightline.vim'
Plug 'https://github.com/justinmk/molokai'
Plug 'https://github.com/cakebaker/scss-syntax.vim'
Plug 'https://github.com/vim-jp/syntax-vim-ex'
Plug 'https://github.com/godlygeek/tabular'
Plug 'https://github.com/wellle/targets.vim'
Plug 'https://github.com/cespare/vim-toml'
Plug 'https://github.com/maralla/vim-toml-enhance'
Plug 'https://github.com/mbbill/undotree'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/christoomey/vim-conflicted'
Plug 'https://github.com/hail2u/vim-css3-syntax'
Plug 'https://github.com/dag/vim-fish'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/airblade/vim-gitgutter'
Plug 'https://github.com/pangloss/vim-javascript'
Plug 'https://github.com/elzr/vim-json.git'
Plug 'https://github.com/vim-pandoc/vim-pandoc.git'
Plug 'https://github.com/vim-pandoc/vim-pandoc-syntax.git'
Plug 'https://github.com/junegunn/vim-peekaboo'
Plug 'https://github.com/tpope/vim-repeat'
Plug 'https://github.com/shmargum/vim-sass-colors'
Plug 'https://github.com/kshenoy/vim-signature'
Plug 'https://github.com/justinmk/vim-sneak'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-unimpaired'
Plug 'https://github.com/dag/vim2hs'
Plug 'https://github.com/tpope/vim-vinegar'
Plug 'https://github.com/kabbamine/yowish.vim'
Plug 'https://github.com/lifepillar/vim-solarized8'
Plug 'https://github.com/ncm2/ncm2'
Plug 'https://github.com/ncm2/ncm2-bufword'
Plug 'https://github.com/ncm2/ncm2-path'
Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}}
Plug 'https://github.com/andymass/vim-matchup'
Plug 'https://github.com/mg979/vim-visual-multi'
Plug 'https://github.com/autozimu/LanguageClient-neovim'
call plug#end()

set background=light
set termguicolors
colorscheme solarized8_high
highlight! link Conceal Normal

let g:fruzzy#usenative = 1

let g:LanguageClient_rootMarkers = ['cabal.project', '*.cabal', 'stack.yaml']
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
    \ 'haskell': ['ghcide', '--lsp'],
    \ }

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
set tabstop=4
set softtabstop=4
set shiftwidth=4
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

set shortmess=fnxoOtT
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

" ~~~~~~~~~~~~~~
" ~~ MAPPINGS ~~
" ~~~~~~~~~~~~~~

" Leader
let mapleader = ";"
let g:mapleader = ";"
let maplocalleader = "'"

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

" Return to last edit position when opening files -------- "
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

map <leader>B :BufExplorer<CR>

map <silent> <leader>n :set number! relativenumber!<CR>

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

autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2

autocmd BufWinLeave * lclose

autocmd FileType text,markdown,pandoc     setlocal nonumber
autocmd FileType text setlocal nospell

autocmd FileType markdown,pandoc call AR_autotoggle_list()

autocmd FileType gitcommit      setlocal textwidth=67

autocmd FileType qf     setlocal wrap linebreak

autocmd FileType haskell setlocal foldmethod=indent foldminlines=6

autocmd FileType table setlocal tabstop=28 noexpandtab nolist

augroup END

function! AR_autotoggle_list()
    augroup list
        autocmd!
        autocmd InsertEnter <buffer=abuf> setlocal nolist
        autocmd InsertLeave <buffer=abuf> setlocal list
    augroup END
endfunction

let g:ncm2#matcher = {
    \ 'name': 'must',
    \ 'matchers': [
    \   {'name': 'base_min_len', 'value': 3},
    \   'abbrfuzzy'
    \ ]}

let g:ncm2#auto_popup = 0
let g:ncm2#total_popup_limit = 10

inoremap <Tab> <C-r>=ncm2#manual_trigger()<CR>

" NCM2 requires noinsert
set completeopt+=noinsert

let g:pandoc#syntax#conceal#blacklist = ['ellipses']
let g:pandoc#formatting#mode = 'h'
let g:pandoc#formatting#textwidth = 60
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 0
let g:pandoc#spell#enabled = 1

let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#label = 1

let g:clever_f_fix_key_direction = 1

let g:haskellmode_completion_ghc = 0

let g:haskell_enable_quantification = 1
let g:haskell_enable_pattern_synonyms = 0
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_in = 1

let g:haskell_conceal_wide = 0
let g:haskell_conceal_enumerations = 0

let g:tagbar_ctags_bin = "/Users/alan/.local/bin/ctags"

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~ elmelmelmelmelmelmelmelmelmelmelm ~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

augroup elm
autocmd!

autocmd FileType elm    map <buffer> <LocalLeader>e <Plug>(elm-error-detail) |
                     \  map <buffer> <LocalLeader>ds <Plug>(elm-show-docs)   |
                     \  map <buffer> <LocalLeader>db <Plug>(elm-browse-docs)

augroup END

let g:elm_setup_keybindings=0
let g:elm_jump_to_error=1
let g:elm_make_show_warnings=1
let g:elm_detailed_complete=1
let g:elm_format_autosave=1
let g:elm_format_args = "--elm-version 0.17"

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~ supertabsupertabsupertabsupertab ~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" set completeopt=longest,menu
" let g:SuperTabLongestEnhanced=1
" let g:SuperTabLongestHighlight=1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~ alealealealealealealealealealealeale ~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = { 'haskell': ['hlint'], 'php': [] }

augroup haskell_ale
au!
autocmd FileType haskell let b:ale_lint_on_text_changed = 'none'
autocmd FileType haskell setl
augroup END

map <Leader>ad :ALEDetail<CR>
map <Leader>ai :ALEInfo<CR>
map <silent> [w :ALEPreviousWrap<CR>
map <silent> ]w :ALENextWrap<CR>

set laststatus=2

let g:haddock_browser="/Applications/Safari.app/Contents/MacOS/Safari"

nnoremap <silent> U :UndotreeToggle<CR>

" Lightline

let g:lightline = {}

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
    return fugitive#head() != '' ? "(" . fugitive#head() . ")" : ''
endfunction

function! AR_gitgutter_status()
    if gitgutter#utility#is_active(bufnr("%"))
        let summary = GitGutterGetHunkSummary()
        return "+" . summary[0] . " ~" . summary[1] . " -" . summary[2]
    else
        return ''
    endif
endfunction

function! AR_fileformat()
    return &ff == "unix" ? "" : &ff
endfunction

function! AR_ale_status()
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
endfunction
