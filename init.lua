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
set clipboard=unnamedplus

set termguicolors

set updatetime=300 timeoutlen=700

set formatoptions-=t textwidth=72

set list listchars=tab:↹·,nbsp:⎵,trail:·,extends:⇉,precedes:⇇
set showbreak=↪︎\ 
set fillchars=vert:│,fold:─
set diffopt=filler,vertical,context:3,internal,algorithm:histogram,closeoff,hiddenoff,indent-heuristic,linematch:60,iwhiteeol
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

set splitbelow splitright
set switchbuf+=useopen
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

set statusline=[%n]\ %.25f\ %(%h\ %)%(%{get(b:,'gitsigns_status','')}\ %)%(%r\ %)%m%=%{reg_recording()}%=%P\ /\ %L\ 

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

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Nomodifiable {{{
augroup nomodifiable
  au!
  au BufWinEnter * if !&modifiable | call NomodifiableMappings() | endif
augroup END
function! NomodifiableMappings() abort
  nnoremap <buffer> <nowait> u <C-u>
  nnoremap <buffer> <nowait> d <C-d>
  if get(g:, 'manpager', 0)
    nnoremap <buffer> <nowait> <Space> <C-f>
    nnoremap <buffer> <nowait> <S-Space <C-b>
  endif
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

if has('mac')
  noremap <C-j> <C-W>j
  noremap <C-k> <C-W>k
  noremap <C-h> <C-W>h
  noremap <C-l> <C-W>l
else
  noremap <A-j> <C-W>j
  noremap <A-k> <C-W>k
  noremap <A-h> <C-W>h
  noremap <A-l> <C-W>l
endif
]]

vim.keymap.set({'n', 'v', 'i'}, vim.fn.has('mac') == 1 and '<D-s>' or '<C-s>', '<cmd>w<cr>')

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
local plugins = {
  'savq/paq-nvim', -- Package manager
  'romainl/vim-cool', -- Only use hlsearch while searching
  'justinmk/vim-dirvish', -- Handy directory viewer
  'dstein64/vim-startuptime', -- Profile vim startup time
  'tpope/vim-unimpaired', -- Paired commands
  'farmergreg/vim-lastplace', -- Remember where I left off
  'tpope/vim-obsession', -- Better session management
  { 'tzachar/highlight-undo.nvim', as = 'highlight-undo', }, -- Highlight changed text on undo/redo
  'mbbill/undotree', -- Nice interface for vim's tree-shaped undo
  'vigoux/notifier.nvim', -- notifications

  -- Motions
  'andymass/vim-matchup', -- More powerful % operator
  'haya14busa/vim-asterisk', -- Better *, #
  'ggandor/leap.nvim', -- s, S, gs motions to jump around quickly

  -- Quickfix
  { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', as = "pqf", }, -- Pretty quickfix
  'romainl/vim-qf', -- Nicer quickfix
  'gabrielpoca/replacer.nvim', -- Editable quickfix

  -- Editing
  'wellle/targets.vim', -- More and better text-objects
  'tpope/vim-repeat', -- Extensible dot-repeat
  'haya14busa/vim-metarepeat', -- Run dot-repeat for each pattern match in selection
  'tpope/vim-surround', -- Manipulate surroundings -- brackets etc
  'AndrewRadev/splitjoin.vim', -- gS, gJ operators for smarter splitting and joining lines

  -- Tree-sitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-textobjects',
  'RRethy/nvim-treesitter-textsubjects',
  'Wansmer/sibling-swap.nvim', -- Swap neighbouring nodes
  'drybalka/tree-climber.nvim', -- Climb trees

  { 'nvim-lualine/lualine.nvim', as = 'lualine', }, -- Statusline

  { 'nvim-lua/plenary.nvim', as = 'plenary' }, -- Support for other plugins, notably Cokeline
  'willothy/nvim-cokeline', -- Bufferline

  -- Color scheme
  { 'mcchrish/zenbones.nvim', as = 'zenbones' },
  { 'rktjmp/lush.nvim', as = 'lush' },
  { 'lifepillar/vim-gruvbox8', branch = 'neovim' },
  'andreypopp/vim-colors-plain',
  'cideM/yui',
  'zekzekus/menguless',
  'jaredgorski/Mies.vim',
  'https://git.sr.ht/~romainl/vim-bruin',
  'ntk148v/komau.vim',
  'kkga/vim-envy',
  'stefanvanburen/rams',

  -- Fuzzy-finding
  'nvim-telescope/telescope.nvim',
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- Language support
  { 'mrcjkb/rustaceanvim', pin = true }, -- Rust

  'NvChad/nvim-colorizer.lua', -- Colours literal
  'lewis6991/gitsigns.nvim', -- Git integration for buffers

  'L3MON4D3/LuaSnip',
}

local installed, paq = pcall(require, 'paq')
if not installed then
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
  vim.loader.reset()
  paq = require 'paq'
  paq.install()
end

paq(plugins)
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
require('leap').add_default_mappings()
require('colorizer').setup {
  filetypes = { 'vim', 'css', 'scss', 'sass', 'lua', },
  user_default_options = {
    css = true,
  },
}

require('sibling-swap').setup {
  keymaps = {
    ['<Leader>;'] = 'swap_with_right',
    ['<Leader>,'] = 'swap_with_left',
  },
}

local tree_maps = {
  ['<M-Up>'] = 'goto_parent',
  ['<M-Down>'] = 'goto_child',
  ['<M-Right>'] = 'goto_next',
  ['<M-Left>'] = 'goto_prev',
}

for keys, func in pairs(tree_maps) do
  local rhs = function() require('tree-climber')[func]() end
  vim.keymap.set({'n', 'x', 'o'}, keys, rhs, { remap = false, silent = true, desc = func })
end

local function gs(f)
  return ("<Cmd>lua require('gitsigns').%s<CR>"):format(f)
end

require('gitsigns').setup {
  on_attach = function(bufnr)
    local function next_hunk()
      if vim.wo.diff then return ']c' end
      return gs("next_hunk({preview=true})")
    end
    local function prev_hunk()
      if vim.wo.diff then return '[c' end
      return gs('prev_hunk({preview=true})')
    end
    local prefix = '<LocalLeader>'
    vim.keymap.set({'n', 'x', 'o'}, '[c', prev_hunk, {buffer = bufnr, expr = true})
    vim.keymap.set({'n', 'x', 'o'}, ']c', next_hunk, {buffer = bufnr, expr = true})
    vim.keymap.set({'n', 'x'}, prefix..'s', gs('stage_hunk()'), {buffer=bufnr})
    vim.keymap.set({'n', 'x'}, prefix..'r', gs('reset_hunk()'), {buffer=bufnr})
    vim.keymap.set({'n', 'x'}, prefix..'p', gs('preview_hunk_inline()'), {buffer=bufnr})
    vim.keymap.set({'n', 'x'}, prefix..'P', gs('preview_hunk()'), {buffer=bufnr})
  end
}

vim.g.zenbones = {
  lightness = 'bright',
  darken_noncurrent_window = true,
  darken_comments = 67,
}

vim.g.gruvbox_filetype_hi_groups = 1

vim.opt.background = 'light'
vim.api.nvim_command('colorscheme rams')

vim.g.qf_mapping_ack_style = 1
vim.g.qf_nowrap = 0

vim.cmd [[
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

require('notifier').setup {}
-- }}}

-- Autocommands {{{
vim.cmd [[
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
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
]]

local compl_ns = vim.api.nvim_create_namespace('')

local function lsp_completedone(client_id)
  return function(args)
    local item = vim.api.nvim_get_vvar('completed_item')
    -- If we don't have an LSP completion item, do nothing
    if type(item.user_data) ~= "table"
      or not item.user_data.nvim or not item.user_data.nvim.lsp
      or not item.user_data.nvim.lsp.completion_item then
      return
    end
    local lsp_item = item.user_data.nvim.lsp.completion_item

    local edits = lsp_item.additionaltextedits or {}
    local snippet = nil
    local cur_pos = vim.api.nvim_win_get_cursor(0)

    -- If it's a snippet textEdit, then ...
    if lsp_item.textEdit and lsp_item.insertTextFormat == 2 then
      -- ... remember the snippet so we can expand it with luasnip
      snippet = lsp_item.textEdit.newText
      -- and change the textEdit so that it deletes the text between the
      -- completion start point and the cursor
      lsp_item.textEdit.newText = ''
      lsp_item.textEdit.range['end'].character = cur_pos[2]
      -- Perform it along with another other text edits we may have
      table.insert(edits, 1, lsp_item.textEdit)
    end

    if #edits > 0 then
      -- From https://github.com/echasnovski/mini.completion/blob/2931438a5eff65f003edc9274aaf4bc9ca0467be/lua/mini/completion.lua#L899
      -- Use extmark to track relevant cursor position after text edits
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
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.hoverProvider then
      vim.keymap.set({'n', 'x'}, 'K', vim.lsp.buf.hover, {buffer = args.buf})
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    vim.keymap.del({'n', 'x'}, 'K', {buffer = args.buf})
  end,
})
-- }}}

local tab = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
local stab = vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true)
local c_n = vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
local c_p = vim.api.nvim_replace_termcodes('<C-p>', true, false, true)
local c_x_c_o = vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
local c_y = vim.api.nvim_replace_termcodes('<C-y>', true, false, true)

vim.keymap.set('i', '<Tab>', function ()
  if vim.fn.pumvisible() == 1 then return c_n end
  local luasnip = require('luasnip')
  if luasnip.locally_jumpable(1) then luasnip.jump(1) end
  local row, col = vim.api.nvim_win_get_cursor(0)
  if col == 0 then return tab end
  local line = vim.api.nvim_get_current_line():sub(1, col)
  if line:match("^%s*$") then return tab end
  if luasnip.expandable() then luasnip.expand() end
  return c_x_c_o
end, {expr = true, remap = false})

vim.keymap.set('i', '<S-Tab>', function ()
  if vim.fn.pumvisible() == 1 then return c_p end
  local luasnip = require('luasnip')
  if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
  local row, col = vim.api.nvim_win_get_cursor(0)
  if col == 0 then return stab end
  local line = vim.api.nvim_get_current_line():sub(1, col)
  if line:match("^%s*$") then return stab end
end, {expr = true, remap = false})

vim.keymap.set('i', '<CR>', function ()
  if vim.fn.pumvisible() == 1 then return c_y else return "\r" end
end, { expr = true, remap = false })

-- vim:foldmethod=marker
