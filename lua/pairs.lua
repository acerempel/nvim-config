local api = vim.api

---@param s string
---@return string
local function term(s)
  return api.nvim_replace_termcodes(s, true, false, true)
end

local M = {}

---@class Pair
---@field left string
---@field right string
---@field expand_space? boolean
---@field expand_cr? boolean
---@field when_not_prior? string
---@field fts_only? string[]
---@field fts_exclude? string[]

---@type Pair[]
M.pairs = {
  { left = '(', right = ')', },
  { left = '{', right = '}' },
  { left = '[', right = ']' },
  { left = "'", right = "'", expand_space = false },
  { left = '"', right = '"', fts_exclude = { "vim" }, expand_space = false },
  { left = '"', right = '"',
    fts_only = { "vim" }, when_not_prior = '^%s*$', expand_space = false },
}

---@param pair Pair
---@return string
local function mapping_left_rhs(pair)
  return pair.left .. pair.right .. term('<C-g>U<Left>')
end

---@param left string
M.mapping_left = function (left)
  ---@type table<string, Pair>
  local pairs = api.nvim_buf_get_var(0, 'auto_pairs_pairs') or {}
  local pair = pairs[left]
  if pair.when_not_prior then
    local pos = api.nvim_win_get_cursor(0)
    local col = pos[2]
    ---@type string
    local line = api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    if prefix:match(pair.when_not_prior) then
      return pair.left
    else
      return mapping_left_rhs(pair)
    end
  else
    return mapping_left_rhs(pair)
  end
end

M.mapping_right = function (right)
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  local line = api.nvim_get_current_line()
  if right == line:sub(col+1,col+1) then
    return term('<C-g>U<Right>')
  elseif ' ' .. right == line:sub(col+1,col+2) then
    return term('<C-g>U<Right><C-g>U<Right>')
  else
    return right
  end
end

---@param delim string
M.mapping_same = function (delim)
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  ---@type string
  local line = api.nvim_get_current_line()
  if delim == line:sub(col+1,col+1) then
    return term('<C-g>U<Right>')
  else
    ---@type table<string, Pair>
    local pairs = api.nvim_buf_get_var(0, 'auto_pairs_pairs') or {}
    local pair = pairs[delim]
    if pair.when_not_prior then
      local prefix = line:sub(1, col)
      if prefix:match(pair.when_not_prior) then
        return delim
      end
    end
    return mapping_left_rhs(pair)
  end
end

M.mapping_cr = function ()
  if vim.fn.pumvisible() == 1 then
    local cmp = require('cmp')
    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
    -- api.nvim_feedkeys(term(vim.fn['coc#_select_confirm']()), 'n', true)
    -- return vim.fn['coc#_select_confirm']()
  else
    -- return term('<C-g>u<CR><C-r>=coc#on_enter()<CR>')
    -- api.nvim_feedkeys(term('<C-g>u<CR>'), 'n', true)
    -- vim.fn['coc#rpc#notify']('CocAutocmd', { 'Enter', api.nvim_get_current_buf() })
    local line = api.nvim_get_current_line()
    local pos = api.nvim_win_get_cursor(0)
    local col = pos[2]
    local left = line:sub(col,col)
    local pairs = api.nvim_buf_get_var(0, 'auto_pairs_pairs')
    local pair = pairs[left]
    local right = pair and pair.right
    if right and right == line:sub(col+1,col+1) then
      api.nvim_feedkeys(term('<CR><Esc>O'), 'n', true)
    else
      api.nvim_feedkeys(term('<CR>'), 'n', true)
    end
  end
end

local function pair_expands_space(pair)
  return pair.expand_space == nil or pair.expand_space
end

local function pair_expands_cr(pair)
  return pair.expand_cr == nil or pair.expand_cr
end

M.mapping_bs = function ()
  local line = api.nvim_get_current_line()
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  local before = line:sub(col,col)
  local after = line:sub(col+1,col+1)
  ---@type table<string, Pair>
  local pairs = api.nvim_buf_get_var(0, 'auto_pairs_pairs')
  local pair = pairs[before]
  if pair and pair.right == after then
    return term('<C-g>U<Right><BS><BS>')
  elseif after == ' ' and before == ' ' then
    local pair = pairs[line:sub(col-1,col-1)]
    if pair and pair_expands_space(pair) and pair.right == line:sub(col+2,col+2) then
      return term('<C-g>U<Right><BS><BS>')
    end
  elseif line:match('^%s*$') then
    local row = pos[1]
    ---@type string[]
    local lines = api.nvim_buf_get_lines(0, row-2, row+1, false)
    local first = lines[1]
    if first then
      local before = first:sub(#first, #first)
      local pair = pairs[before]
      if pair and pair_expands_cr(pair) and lines[3] and lines[3]:match('^%s*%' .. pair.right) then
        return term('<Esc>ddkJxi')
      end
    end
  end
  return term('<BS>')
end

M.mapping_space = function ()
  ---@type string
  local line = api.nvim_get_current_line()
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  local prev = line:sub(col,col)
  ---@type table<string, Pair>
  local pairs = api.nvim_buf_get_var(0, 'auto_pairs_pairs')
  local pair = pairs and pairs[prev]
  if pair and pair_expands_space(pair) and pair.right == line:sub(col+1,col+1) then
    return term('  <C-g>U<Left>')
  else
    return ' '
  end
end

---Should this pair be active for this filetype?
---@param pair Pair
---@param filetype string
---@return boolean
local function pair_active_for_ft(pair, filetype)
  local active = true
  if type(pair.fts_only) == 'table' then
    active = vim.tbl_contains(pair.fts_only, filetype)
  elseif type(pair.fts_exclude) == 'table' then
    active = not vim.tbl_contains(pair.fts_exclude, filetype)
  end
  return active
end

local function imap(lhs, rhs)
  api.nvim_buf_set_keymap(0, 'i', lhs, rhs, { noremap = true })
end

local function imap_expr(lhs, rhs)
  local options = {
    expr = true, noremap = true, silent = true
  }
  api.nvim_buf_set_keymap(0, 'i', lhs, rhs, options)
end

---Set up mapping for current buffer.
---@param pair Pair
local function setup_pair_mappings(pair)
  if pair.left ~= pair.right then
    local rhs = pair.left .. pair.right .. '<C-g>U<Left>'
    if pair.when_not_prior then
      imap_expr(pair.left, 'v:lua.auto_pairs.mapping_left(' .. pair.left .. ')')
    else
      imap(pair.left, rhs)
    end
    imap_expr(pair.right, 'v:lua.auto_pairs.mapping_right("' .. pair.right .. '")')
  else
    local str = nil
    if pair.left:find("'", 1, true) then
      str = string.format('"%s"', pair.left)
    else
      str = string.format("'%s'", pair.left)
    end
    imap_expr(pair.left, 'v:lua.auto_pairs.mapping_same(' .. str .. ')')
  end
end

M.setup_filetype = function()
  local filetype = api.nvim_buf_get_option(0, 'filetype')
  local buf_pairs = {}
  for _, pair in ipairs(M.pairs) do
    if pair_active_for_ft(pair, filetype) then
      buf_pairs[pair.left] = pair
      setup_pair_mappings(pair)
    end
  end
  api.nvim_buf_set_var(0, 'auto_pairs_pairs', buf_pairs)
  if api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' then
    imap('<CR>', '<Cmd>lua auto_pairs.mapping_cr()<CR>')
  end
  imap_expr('<BS>', 'v:lua.auto_pairs.mapping_bs()')
  imap_expr('<Space>', 'v:lua.auto_pairs.mapping_space()')
end

_G.auto_pairs = M

vim.cmd [[
  augroup auto_pairs
  autocmd!
  autocmd FileType * lua auto_pairs.setup_filetype()
  augroup END
]]
