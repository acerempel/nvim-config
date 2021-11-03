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

set mouse=a

set incsearch inccommand=nosplit nohlsearch
set noshowmode showcmd
set clipboard=unnamed

set updatetime=300 timeoutlen=700

set formatoptions=croqj textwidth=80
set autoindent nojoinspaces

set list listchars=tab:↹·,nbsp:⎵,trail:·,extends:⇉,precedes:⇇
set showbreak=↪︎
set fillchars=vert:│,fold:─
set diffopt=filler,vertical,context:3,internal,algorithm:histogram,closeoff,hiddenoff,indent-heuristic
set nowrap linebreak breakindent
set foldlevelstart=2
set foldtext=v:lua.require'foldtext'.foldtext()

set linespace=6
set foldminlines=6
set concealcursor=nc

set scrolloff=2 sidescrolloff=4 sidescroll=1
set nostartofline

set expandtab tabstop=2 softtabstop=2
set shiftwidth=2 shiftround

set backspace=indent,eol,start
set virtualedit=block,onemore
set nostartofline

set ignorecase smartcase gdefault

set splitbelow splitright equalalways
set switchbuf=uselast,useopen,usetab
set guioptions-=L
let no_buffers_menu = 0
set lazyredraw

set undofile undodir=~/.local/share/nvim/undo
set noswapfile nobackup nowritebackup
set history=10000
set viewoptions=cursor,folds,slash,unix
set sessionoptions=blank,buffers,curdir,resize,tabpages,terminal,winpos,winsize,slash,unix

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

hi default link LspReferenceText Folded
hi default link LspReferenceRead StatusLine
hi default link LspReferenceWrite Search

highlight! link Conceal Normal
" highlight NormalFloat guibg=#e4d8ca
" highlight FloatBorder guibg=#e4d8ca
" }}}

" AUTOCOMMANDS {{{

augroup reload
  autocmd!
  " Automatically enable changes to plugin configuration
  autocmd BufWritePost plugins.lua lua package.loaded.plugins = false; require('plugins').compile()
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" }}}

" Packer lazy-loading {{{
" let s:packer_commands = ["Install", "Status", "Sync", "Update", "Load", "Compile", "Profile"]
" for command in s:packer_commands
"   exe "command! -nargs=* Packer" .. command "exe \"lua require('packer').init()\" | Packer" .. command
" endfor
command! -nargs=* -complete=customlist,v:lua.require'plugins'.plugin_complete PackerInstall lua require('plugins').install(<f-args>)
command! -nargs=* -complete=customlist,v:lua.require'plugins'.plugin_complete PackerUpdate lua require('plugins').update(<f-args>)
command! -nargs=* -complete=customlist,v:lua.require'plugins'.plugin_complete PackerSync lua require('plugins').sync(<f-args>)
command! PackerClean lua require('plugins').clean()
command! PackerCompile lua require('plugins').compile()
command! PackerProfile lua require('plugins').profile_output()
command! -nargs=+ -complete=customlist,v:lua.require'plugins'.loader_complete PackerLoad | lua require('plugins').loader(<q-args>)
" }}}

" MAPPINGS {{{

" Leaders {{{
let mapleader = " "
let g:mapleader = " "
let maplocalleader = ","
map <Space> <Nop>
map , <Nop>
map ; <Nop>
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
inoremap <C-l> <Esc>
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

" Don't load netrw, I don't need it
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

let php_html_in_strings=0
let php_html_in_heredoc=0
let php_html_in_nowdoc=0

" Use matchup instead
let g:loaded_matchit = 1
" }}}

" If attached to VS Code {{{
if exists('g:vscode')
  source <sfile>:h/vscode.vim
  finish
endif
" }}}

" MAPPINGS (non-VSCode only) {{{

nnoremap <silent> <Leader>td <Cmd>tcd %:h<CR>
nnoremap <silent> <Leader>tn <Cmd>tabnew<CR>
nnoremap <silent> <Leader>tc <Cmd>tabclose<CR>

nnoremap <silent> U <Cmd>UndotreeToggle<CR>

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
      \<Cmd>lua require('hlslens').start()<CR>
noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
      \<Cmd>lua require('hlslens').start()<CR>
noremap * *<Cmd>lua require('hlslens').start()<CR>
noremap # #<Cmd>lua require('hlslens').start()<CR>
noremap g* g*<Cmd>lua require('hlslens').start()<CR>
noremap g# g#<Cmd>lua require('hlslens').start()<CR>

" use : instead of <Cmd>
nnoremap <silent> <leader>l :noh<CR>

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
" }}}

" AUTOCOMMANDS (non-VSCode only) {{{

augroup terminal
  au!
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
augroup END

augroup filetypes
  autocmd!
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
ENDLUA
" }}}

" COC mappings {{{

augroup coc_mappings
  au!
  au User CocNvimInit lua require('coc').setup_coc_maps()
augroup END

" }}}

" vim:foldmethod=marker:foldenable
