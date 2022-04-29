if !has('nvim-0.7')
  echoerr "Neovim too old!!"
  exit
endif

lua require('impatient')

" OPTIONS {{{

set mouse=a

set inccommand=nosplit nohlsearch
set noshowmode
set clipboard=unnamed

set updatetime=300 timeoutlen=700

set formatoptions=croqj textwidth=72

set list listchars=tab:↹·,nbsp:⎵,trail:·,extends:⇉,precedes:⇇
set showbreak=↪︎\ 
set fillchars=vert:│,fold:─
set diffopt=filler,vertical,context:3,internal,algorithm:histogram,closeoff,hiddenoff,indent-heuristic
set nowrap linebreak breakindent
set foldlevelstart=2
set foldtext=v:lua.require'foldtext'.foldtext()

set linespace=6
set foldminlines=6
set concealcursor=nc

set scrolloff=2 sidescrolloff=4

set expandtab tabstop=2 softtabstop=2
set shiftwidth=2 shiftround

set virtualedit=block,onemore

set ignorecase smartcase gdefault
set completeopt-=preview

set splitbelow splitright equalalways
set switchbuf+=useopen,usetab
set guioptions-=L
let no_buffers_menu = 0
set lazyredraw

set undofile
set noswapfile nobackup nowritebackup
set shada-=%
set jumpoptions=stack
set viewoptions=curdir,cursor,folds
set sessionoptions=blank,buffers,curdir,folds,tabpages,terminal,winpos,winsize

set shortmess=fnxoOtTc
set signcolumn=yes

set wildchar=<Tab>
set wildmode=longest:full,full
set wildignore=*.o,*.hi,*/dist-newstyle/*,*/.stack-work/*,*/node_modules/*,*/elm-stuff/*

set exrc secure

set guifont=Iosevka:h15

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

command! -nargs=+ Find execute 'silent grep! <args>'

" }}}

" COLOURS {{{
set termguicolors

hi default link LspReferenceText Folded
hi default link LspReferenceRead StatusLine
hi default link LspReferenceWrite Search

highlight! link Conceal Normal
" }}}

" AUTOCOMMANDS {{{

augroup reload
  autocmd!
  " Automatically enable changes to plugin configuration
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

augroup omnifunc
  autocmd!
  autocmd FileType * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
augroup END

augroup filetypes
  autocmd!
  autocmd FileType table setlocal tabstop=28 noexpandtab nolist
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

" Packer lazy-loading {{{
command! -nargs=* -complete=customlist,v:lua.require'plugins'.plugin_complete PackerInstall lua require('plugins').install(<f-args>)
command! -nargs=* -complete=customlist,v:lua.require'plugins'.plugin_complete PackerUpdate lua require('plugins').update(<f-args>)
command! -nargs=* -complete=customlist,v:lua.require'plugins'.plugin_complete PackerSync lua require('plugins').sync(<f-args>)
command! PackerClean lua require('plugins').clean()
command! PackerCompile lua require('plugins').compile()
command! PackerProfile lua require('plugins').profile_output()
command! -nargs=+ -complete=customlist,v:lua.require'plugins'.loader_complete PackerLoad | lua require('plugins').loader(<q-args>)
" }}}

" Abbreviations {{{
cnoreabbrev ps PackerSync
cnoreabbrev pi PackerInstall
cnoreabbrev pp PackerProfile
cnoreabbrev pc PackerClean

" Otherwise it's short for :langnoremap
cnoreabbrev ln lnext
cnoreabbrev tel Telescope
" }}}

" MAPPINGS {{{

" Leaders {{{
let mapleader = " "
let g:mapleader = " "
let maplocalleader = ","
map <Space> <Nop>
map , <Nop>
noremap ; :
" }}}

" Moving around {{{
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
noremap ` <C-W>w
noremap ~ <C-W>W

inoremap <expr> <C-E> pumvisible() ? "<C-E>" : "<End>"
inoremap <C-A> <Home>
" Normally <C-F> re-indents the current line, but I've never used that
inoremap <C-F> <Right>
inoremap <C-B> <Left>
snoremap <C-E> <Esc>`>a
snoremap <C-A> <Esc>`<i
inoremap <M-Left> <S-Left>
inoremap <M-Right> <S-Right>
inoremap <D-Left> <Home>
inoremap <D-Right> <End>
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : "\<Down>"

" I want this to be remapped, because I map gd to LSP functionality when
" applicable.
nmap <CR> gd

noremap Z "_d
noremap ZZ "_dd

noremap gb go

noremap ' `
tnoremap <Esc> <c-\><c-n>

" }}}

" Nomodifiable {{{
augroup nomodifiable
  au!
  au BufWinEnter * if !&modifiable | call NomodifiableMappings() | endif
augroup END
function! NomodifiableMappings() abort
  nnoremap <buffer> <nowait> u <C-u>
  nnoremap <buffer> <nowait> d <C-d>
  if &ft != 'man' | nnoremap <buffer> <nowait> q <Cmd>close<CR> | endif
endfunction
" }}}

" Command-line prefix :tab or :vert{{{
cnoremap <expr> <C-T> getcmdtype() == ':' ? "<C-\>eToggleTab()<CR>" : "<C-T>"
cnoremap <expr> <C-S> getcmdtype() == ':' ? "<C-\>eToggleVsplit()<CR>" : "<C-S>"

function! ToggleTab() abort
  let line = getcmdline()
  if match(line, "tab ") == 0
    call setcmdpos(max([1, getcmdpos() - 4]))
    return strpart(line, 4)
  else
    call setcmdpos(getcmdpos() + 4)
    return "tab " .. line
  endif
endfunction

function! ToggleVsplit() abort
  let line = getcmdline()
  let matched = matchstr(line, 'vert\%[ical] ')
  if matched != ""
    let match_len = strlen(matched)
    call setcmdpos(max([1, getcmdpos() - match_len]))
    return strpart(line, match_len)
  else
    call setcmdpos(getcmdpos() + 5)
    return "vert " .. line
  endif
endfunction
"}}}

nnoremap <silent> <Leader>td <Cmd>tcd %:h<CR>
nnoremap <silent> <Leader>tn <Cmd>tabnew<CR>
nnoremap <silent> <Leader>tc <Cmd>tabclose<CR>

nnoremap <silent> <Plug>(search-workspace) <cmd>lua require'telescope.builtin'.live_grep({ additional_args = '-F' })<CR>
nnoremap <silent> <Plug>(search-document) <cmd>lua require('telescope.builtin').treesitter()<CR>
inoremap <silent> <Plug>(search-workspace) <cmd>lua require'telescope.builtin'.live_grep({ additional_args = '-F' })<CR>
inoremap <silent> <Plug>(search-document) <cmd>lua require('telescope.builtin').treesitter()<CR>

nnoremap <silent> U <Cmd>UndotreeToggle<CR>

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" }}}

" Misc plugin settings {{{
let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#label = exists('g:vscode') ? 0 : 1

let g:clever_f_fix_key_direction = 1

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Don't load netrw, I don't need it
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" Enable new filetype.lua
let g:do_filetype_lua = 1
" Disable traditional filetype detection
let g:did_load_filetypes = 0

let php_html_in_strings=0
let php_html_in_heredoc=0
let php_html_in_nowdoc=0

" Use matchup instead
let g:loaded_matchit = 1
" }}}

" Misc lua config {{{
lua require('help_float').setup {}
" }}}

command! -nargs=0 BufferClose call DoCloseBuffer()

function! DoCloseBuffer() abort
  if winnr('$') > 1
    close
  else
    bdelete
  endif
endfunction

" vim:foldmethod=marker:foldenable
