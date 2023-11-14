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

set shortmess-=l
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

let g:mapleader = ' '
let g:maplocalleader = '\'
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

for ix = 1, 8 do
  rhs = string.format("<cmd>buf %s<cr>", ix)
  lhs = '<M-' .. ix .. '>'
  vim.keymap.set({'n', 'v', 'i'}, lhs, rhs)
end
vim.keymap.set({'n', 'v', 'i'}, '<C-9>', '<cmd>blast<cr>')

vim.keymap.set({'n', 'x'}, ']d', vim.diagnostic.goto_next, {desc = "Next diagnostic"})
vim.keymap.set({'n', 'x'}, '[d', vim.diagnostic.goto_prev, {desc = "Previous diagnostic"})

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
  'cideM/yui',
  'zekzekus/menguless',
  'Verf/deepwhite.nvim',
  'miikanissi/modus-themes.nvim',
  'd00h/nvim-rusticated',
  'jaredgorski/Mies.vim',

  -- Fuzzy-finding
  'nvim-telescope/telescope.nvim',
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  'L3MON4D3/LuaSnip',
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
require('leap').add_default_mappings()
require('flit').setup()

vim.g.zenbones = {
  lightness = 'bright',
  darken_noncurrent_window = true,
  darken_comments = 67,
}

vim.g.gruvbox_filetype_hi_groups = 1

vim.opt.background = 'light'
vim.api.nvim_command('colorscheme yui')
-- vim.api.nvim_command('hi StatusLine gui=NONE guifg=#454545')
-- vim.api.nvim_command('hi StatusLineNC gui=NONE guifg=#676767')

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
    clear_time = 3000,
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

local compl_ns = vim.api.nvim_create_namespace('')

local function lsp_completedone(client_id)
  return function(args)
    local item = vim.api.nvim_get_vvar('completed_item')
    if type(item.user_data) ~= "table"
      or not item.user_data.nvim or not item.user_data.nvim.lsp
      or not item.user_data.nvim.lsp.completion_item then
      return
    end
    local lsp_item = item.user_data.nvim.lsp.completion_item

    local edits = lsp_item.additionaltextedits or {}
    local snippet = nil
    if lsp_item.textEdit then
      if lsp_item.insertTextFormat == 2 then
        snippet = lsp_item.textEdit.newText
        lsp_item.textEdit.newText = ''
        item.word = ''
        table.insert(edits, 1, item.textEdit)
      end
    end

    if #edits > 0 then
      -- Use extmark to track relevant cursor position after text edits
      local cur_pos = vim.api.nvim_win_get_cursor(0)
      local extmark_id = vim.api.nvim_buf_set_extmark(0, compl_ns, cur_pos[1] - 1, cur_pos[2], {})

      local offset_encoding = vim.lsp.get_client_by_id(client_id).offset_encoding
      vim.lsp.util.apply_text_edits(edits, vim.api.nvim_get_current_buf(), offset_encoding)

      local extmark_data = vim.api.nvim_buf_get_extmark_by_id(0, compl_ns, extmark_id, {})
      pcall(vim.api.nvim_buf_del_extmark, 0, compl_ns, extmark_id)
      pcall(vim.api.nvim_win_set_cursor, 0, { extmark_data[1] + 1, extmark_data[2] })
    end

    if snippet then
      require('luasnip').lsp_expand(snippet)
    end
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      vim.api.nvim_create_autocmd("CompleteDone", {callback = lsp_completedone(args.data.client_id), buffer = bufnr})
    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end
    if client.server_capabilities.documentRangeFormattingProvider then
      vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
    end
    if client.server_capabilities.hoverProvider then
      vim.keymap.set({'n', 'x'}, 'K', vim.lsp.buf.hover, {buffer = bufnr})
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    vim.api.nvim_command("setlocal tagfunc< omnifunc< formatexpr<")
  end,
})
-- }}}

local tab = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
local stab = vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true)
local c_n = vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
local c_p = vim.api.nvim_replace_termcodes('<C-p>', true, false, true)
local c_x_c_o = vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)

vim.keymap.set('i', '<Tab>', function ()
  if vim.fn.pumvisible() == 1 then return c_n end
  local row, col = vim.api.nvim_win_get_cursor(0)
  if col == 0 then return tab end
  local line = vim.api.nvim_get_current_line():sub(1, col)
  if line:match("^%s*$") then return tab end
  return c_x_c_o
end, {expr = true, remap = false})

vim.keymap.set('i', '<S-Tab>', function ()
  if vim.fn.pumvisible() == 1 then return c_p end
  local row, col = vim.api.nvim_win_get_cursor(0)
  if col == 0 then return stab end
  local line = vim.api.nvim_get_current_line():sub(1, col)
  if line:match("^%s*$") then return stab end
end, {expr = true, remap = false})
