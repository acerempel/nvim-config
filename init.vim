if !has('nvim-0.5')
  echoerr "Neovim too old!!"
  exit
endif

lua require('impatient')

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
set foldminlines=6
set concealcursor=nc

set scrolloff=2 sidescrolloff=4 sidescroll=1
set nostartofline

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
set viewoptions=cursor,folds,slash,unix
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,terminal,winpos,winsize,slash,unix

set shortmess=fnxoOtTc
set signcolumn=yes

set wildchar=<Tab>
set wildmode=longest:full,full
set wildignore=*.o,*.hi,*/.git/*,*/dist-newstyle/*,*/.stack-work/*,*/node_modules/*,*/elm-stuff/*

" Remember info about open buffers on close -------------- "
set shada^=%
set hidden

set exrc secure

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

command! -nargs=+ Find execute 'silent grep! <args>'

" }}}

" COLOURS {{{
set termguicolors
let g:gruvbox_bold = 1
let g:gruvbox_plugin_hi_groups = 1
let g:gruvbox_filetype_hi_groups = 1
set background=light

hi default link LspReferenceText Folded
hi default link LspReferenceRead StatusLine
hi default link LspReferenceWrite Search

colorscheme gruvbox8_hard

highlight! link Conceal Normal
highlight NormalFloat guibg=#e4d8ca
highlight FloatBorder guibg=#e4d8ca
" }}}

" AUTOCOMMANDS {{{

augroup reload
  autocmd!
  " Automatically enable changes to plugin configuration
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" }}}

" MAPPINGS {{{

" Leaders {{{
let mapleader = " "
let g:mapleader = " "
let maplocalleader = ","

noremap <silent> <Space> <Nop>
" }}}

" Moving around {{{
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
noremap ` <C-W>w
noremap ~ <C-W>W

noremap Q @@
noremap Z "_d
noremap ZZ "_dd

noremap gb go

" Make Y editor command consistent with D, C, etc.
noremap Y y$

noremap ' `
" }}}

" }}}

" Misc plugin settings {{{
let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#label = 1

let g:clever_f_fix_key_direction = 1

let g:far#source = 'rgnvim'

let g:haddock_browser="/Applications/Safari.app/Contents/MacOS/Safari"

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1
let g:vim_svelte_plugin_use_foldexpr = 1

let php_html_in_strings=0
let php_html_in_heredoc=0
let php_html_in_nowdoc=0
" }}}

" If attached to VS Code {{{
if exists('g:vscode')
  " Use VS Code's comment support
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine

  nnoremap <silent> za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
  nnoremap <silent> zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
  nnoremap <silent> zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
  nnoremap <silent> zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
  nnoremap <silent> zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
  nnoremap <silent> zc <Cmd>call VSCodeNotify('editor.fold')<CR>
  nnoremap <silent> zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>

  nnoremap <silent> z1 <Cmd>call VSCodeNotify('editor.foldLevel1')<CR>
  nnoremap <silent> z2 <Cmd>call VSCodeNotify('editor.foldLevel2')<CR>
  nnoremap <silent> z3 <Cmd>call VSCodeNotify('editor.foldLevel3')<CR>
  nnoremap <silent> z4 <Cmd>call VSCodeNotify('editor.foldLevel4')<CR>
  nnoremap <silent> z5 <Cmd>call VSCodeNotify('editor.foldLevel5')<CR>
  nnoremap <silent> z6 <Cmd>call VSCodeNotify('editor.foldLevel6')<CR>
  nnoremap <silent> z7 <Cmd>call VSCodeNotify('editor.foldLevel7')<CR>

  xnoremap <silent> zV <Cmd>call VSCodeNotify('editor.foldAllExcept')<CR>

  nnoremap gD <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
  xnoremap gD <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
  nnoremap g] <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  xnoremap g] <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  nnoremap g} <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  xnoremap g} <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  nnoremap gO <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
  nnoremap go <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
  
  " VSCode doesn't have commands for these apparently.
  noremap zv <Nop>
  noremap zr <Nop>
  noremap zm <Nop>
  
  noremap ]d <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
  noremap [d <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
  
  nnoremap gh <Cmd>call VSCodeNotify('editor.action.changeAll')<CR>
  xnoremap gh <Cmd>call VSCodeNotifyVisual('editor.action.selectHighlights', v:false)<CR>
  
  " Allow remapping, since gj and gk are mapped to VSCode commands.
  map <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  map <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
  
  " Matchparen does funny things inside VSCode – problem with its InsertLeave autocmd.
  let g:matchup_matchparen_enabled = 0

  finish
endif
" }}}

" MAPPINGS (non-VSCode only) {{{

nnoremap <silent> <Leader>td <Cmd>tcd %:h<CR>
nnoremap <silent> <Leader>tn <Cmd>tabnew<CR>
nnoremap <silent> <Leader>tc <Cmd>tabclose<CR>

nnoremap ; <Cmd>call luaeval("require'harpoon.ui'.nav_file(_A)", v:count1)<CR>
nnoremap <Leader>bb <Cmd>call luaeval("require'harpoon.ui'.nav_file(_A)", v:count1)<CR>
nnoremap <Leader>ba <Cmd>lua require'harpoon.mark'.add_file()<CR>
nnoremap <Leader>be <Cmd>lua require'harpoon.ui'.toggle_quick_menu()<CR>

nnoremap <silent> U <Cmd>UndotreeToggle<CR>

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" }}}

" AUTOCOMMANDS (non-VSCode only) {{{

augroup terminal
  au!
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
augroup END

augroup filetypes
  autocmd!
  autocmd FileType prose     setlocal nonumber fo+=t tw=72
  autocmd FileType prose setlocal spell
  autocmd FileType qf     setlocal wrap linebreak
  autocmd FileType table setlocal tabstop=28 noexpandtab nolist
  autocmd BufReadPost,BufNew *.wiki ++once packadd vimwiki
augroup END

function! SetTreeSitterFolding() abort
  setlocal foldenable
  setlocal foldmethod=expr
  setlocal foldexpr=nvim_treesitter#foldexpr()
endfunction

augroup treesitter
  au!
  au FileType rust,javascript,typescript,javascriptreact,typescriptreact,lua,nix,php,html,css,scss,sass,vim call SetTreeSitterFolding()
augroup END

" }}}

" Misc lua config {{{
lua << ENDLUA
  _G.check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
    else
      return false
    end
  end

  require('pairs')
ENDLUA
" }}}

" Telescope {{{
cmap <C-R> <Plug>(TelescopeFuzzyCommandSearch)
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>
" }}}

" COC mappings {{{

augroup coc_mappings
  au!
  au User CocNvimInit lua require('coc').setup_coc_maps()
augroup END

" }}}

" vim:foldmethod=marker:foldenable
