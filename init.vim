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

" Return to last edit position when opening files -------- "
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" If we are running inside VS Code
if exists('g:vscode')
  " Use VS Code's comment support
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
  
  lua require('plugins')
  finish
endif

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
  autocmd FileType cabal au BufWritePre <buffer=abuf> %!cabal-fmt | norm g'.
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
  if vim.g.vscode == nil then
    require('lsp')
    require('mappings')
    require('snippets')
    require('pairs')
  end
ENDLUA

" MAPPINGS {{{

" Leaders {{{
let mapleader = " "
let g:mapleader = " "
let maplocalleader = ","

noremap <silent> <Space> <Nop>
" }}}

" Moving around {{{
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

nnoremap ; <Cmd>call luaeval("require'harpoon.ui'.nav_file(_A)", v:count1)<CR>
nnoremap <Leader>bb <Cmd>lua require'harpoon.mark'.add_file()<CR>
nnoremap <Leader>be <Cmd>lua require'harpoon.ui'.toggle_quick_menu()<CR>

nnoremap <silent> U <Cmd>UndotreeToggle<CR>

noremap Q @@
nnoremap _ "_d

" imap <C-j> <Down>
" imap <C-k> <Up>
" imap <C-h> <Left>
" imap <C-l> <Right>

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

" Pandoc settings {{{
let g:pandoc#syntax#conceal#blacklist = ['ellipses']
let g:pandoc#formatting#mode = 'h'
let g:pandoc#formatting#textwidth = 60
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 0
let g:pandoc#spell#enabled = 1

function! ZoteroCite()
  " pick a format based on the filetype (customize at will)
  let format = &filetype =~ '.*tex' ? 'citep' : 'pandoc'
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format.'&brackets=1'
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

noremap <leader>z "=ZoteroCite()<CR>p
inoremap <C-z> <C-r>=ZoteroCite()<CR>
" }}}

" Vimwiki settings {{{
let g:vimwiki_list =
  \ [{'path': '~/Documents/Grand-Schemes',
  \   'path_html': '~/Documents/Grand-Schemes/Hypertext',
  \   'index': 'Index',
  \   'auto_toc': 1,
  \   'syntax': 'default',
  \   'ext': '.wiki',
  \   'template_path': '~/Documents/Grand-Schemes/Templates',
  \   'template_default': 'default',
  \   'template_ext': '.template.html',
  \   'diary_rel_path': 'Catalogue-of-Days',
  \   'diary_index': 'Days',
  \   'diary_header': 'The Catalogue of Days',
  \   'diary_sort': 'desc',
  \   'auto_tags': 1,
  \   'auto_diary_index': 1,
  \ }]

let g:vimwiki_dir_link = 'Index'
let g:vimwiki_html_header_numbering = 2
let g:vimwiki_html_header_numbering_sym = '.'
let g:vimwiki_autowriteall = 0
let g:vimwiki_ext2syntax = {}
let g:vimwiki_global_ext = 0
" }}}

" vim:foldmethod=marker:foldenable
