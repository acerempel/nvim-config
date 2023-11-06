vim.cmd [[
if !has('nvim-0.7')
  echoerr "Neovim too old!!"
  exit
  endif
]]

vim.loader.enable()

-- Options {{{
vim.cmd [[
set noshowmode
set cmdheight=0
set clipboard=unnamedplus

set termguicolors

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
set shada-=%
set jumpoptions=stack,view

set shortmess=fnxoOtTc
set signcolumn=yes

set wildmode=longest:full,full
set wildignore=*.o,*.hi,*/dist-newstyle/*,*/.stack-work/*,*/node_modules/*,*/elm-stuff/*

set exrc secure

set guifont=Iosevka:h15

set statusline=\ %n\ %-f\ %y\ %(%r\ %)%m%=%P\ of\ %L\ 

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

command! -nargs=+ Find execute 'silent grep! <args>'
]] -- }}}

-- Mappings {{{
vim.cmd [[
" Nomodifiable {{{
augroup nomodifiable
  au!
  au BufWinEnter * if !&modifiable | call NomodifiableMappings() | endif
augroup END
function! NomodifiableMappings() abort
  nnoremap <buffer> <nowait> u <C-u>
  nnoremap <buffer> <nowait> d <C-d>
  nnoremap <buffer> <nowait> <Space> <C-f>
  nnoremap <buffer> <nowait> <S-Space <C-b>
  if &ft != 'man' | nnoremap <buffer> <nowait> q <Cmd>close<CR> | endif
endfunction
" }}}

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

if has('win32')
  noremap <A-j> <C-W>j
  noremap <A-k> <C-W>k
  noremap <A-h> <C-W>h
  noremap <A-l> <C-W>l
else
  noremap <C-j> <C-W>j
  noremap <C-k> <C-W>k
  noremap <C-h> <C-W>h
  noremap <C-l> <C-W>l
endif
]]

vim.keymap.set({'n', 'v', 'i'}, '<C-s>', '<cmd>w<cr>')
-- }}}

-- Plugin management {{{
require 'paq' {
  -- Package manager
  'savq/paq-nvim',

  -- More powerful % operator
  'andymass/vim-matchup',

  -- Only use hlsearch while searching
  'romainl/vim-cool',

  -- Better *, #
  'haya14busa/vim-asterisk',

  -- s, S, gs motions to jump around quickly
  'ggandor/leap.nvim',

  -- enhanced f, F, t, T
  'ggandor/flit.nvim',

  -- Handy directory viewer
  'justinmk/vim-dirvish',

  -- Profile vim startup time
  'dstein64/vim-startuptime',

  -- Paired commands
  'tpope/vim-unimpaired',

  -- Pretty quickfix
  { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', as = "pqf", },

  -- Nicer quickfix
  'romainl/vim-qf',

  -- Editable quickfix
  'gabrielpoca/replacer.nvim',

  -- Remember where I left off
  'farmergreg/vim-lastplace',

  -- Better session management
  'tpope/vim-obsession',

  -- More and better text-objects
  'wellle/targets.vim',

  -- Highlight command-line ranges
  'winston0410/cmd-parser.nvim',
  'winston0410/range-highlight.nvim',

  -- Show register contents upon pressing " etc
  { 'tversteeg/registers.nvim', as = 'registers' },

  -- Highlight changed text on undo/redo
  { 'tzachar/highlight-undo.nvim', as = 'highlight-undo', },

  -- Nice interface for vim's tree-shaped undo
  'mbbill/undotree',

  -- Extensible dot-repeat
  'tpope/vim-repeat',

  -- Run dot-repeat for each pattern match in selection
  'haya14busa/vim-metarepeat',

  -- Manipulate surroundings -- brackets etc
  'tpope/vim-surround',

  -- gS, gJ operators for smarter splitting and joining lines
  'AndrewRadev/splitjoin.vim',

  -- Don't move cursor or discard selection on <, >, = operators
  { 'gbprod/stay-in-place.nvim', as = 'stay-in-place' },

  -- Tree-sitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-textobjects',
  'RRethy/nvim-treesitter-textsubjects',

  -- Highlight function arguments and their use sites
  { 'm-demare/hlargs.nvim', as = 'hlargs', },

  -- Statusline
  { 'nvim-lualine/lualine.nvim', as = 'lualine', },

  -- Support for other plugins, notably Cokeline
  { 'nvim-lua/plenary.nvim', as = 'plenary' },

  -- Bufferline
  'willothy/nvim-cokeline',

  -- Color scheme
  { 'mcchrish/zenbones.nvim', as = 'zenbones' },
  { 'rktjmp/lush.nvim', as = 'lush' },
  { 'lifepillar/vim-gruvbox8', branch = 'neovim' },
  'andreypopp/vim-colors-plain',
}
-- }}}

-- Disable some built-in plugins {{{
vim.cmd [[
  " Don't load netrw, I don't need it
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1

  let php_html_in_strings=0
  let php_html_in_heredoc=0
  let php_html_in_nowdoc=0

  " Use matchup instead
  let g:loaded_matchit = 1
  let loaded_matchparen = 1
]]
-- }}}

-- Plugin configuration {{{
require('pqf').setup()
require('highlight-undo').setup()
require('stay-in-place').setup()
require('registers').setup()
require('leap').add_default_mappings()
require('flit').setup()
require('range-highlight').setup()

require('hlargs').setup {
  performance = {
    parse_delay = 15,
    slow_parse_delay = 100,
    debounce = {
      partial_parse = 30,
      partial_insert_mode = 450,
    }
  }
}

vim.api.nvim_command('hi! link Hlargs Constant')

vim.g.zenbones = {
  lightness = 'bright',
  darken_noncurrent_window = true,
  darken_comments = 67,
}

vim.g.gruvbox_filetype_hi_groups = 1

vim.opt.background = 'light'
vim.api.nvim_command('colorscheme plain')

vim.cmd [[
  " vim-qf
  let g:qf_mapping_ack_style = 1
  let g:qf_nowrap = 0

  " vim-asterisk
  let g:asterisk#keeppos = 1
  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  map gz# <Plug>(asterisk-gz#)
]]

-- vim-matchup
vim.g.matchup_matchparen_offscreen = {
  method = 'popup',
  scrolloff = 1,
}
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_deferred_fade_time = 450
vim.g.matchup_surround_enabled = 1
vim.g.matchup_matchpref = { html = { tagnameonly = 1 } }
if vim.g.vscode == 1 then
  vim.g.matchup_matchparen_enabled = 0
end

require('notifier').setup {
  notify = {
    clear_time = 1500,
  }
}
-- }}}

-- Autocommands {{{
vim.cmd [[
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

augroup terminal
  autocmd!
  autocmd TermOpen fish,bash,zsh,sh startinsert
augroup END
" }}}
]]
-- }}}
