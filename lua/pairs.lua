local these_pairs = {
  { '(', ')', },
  { '{', '}' },
  { '[', ']' },
  { "'", "'" },
  { '"', '"' },
}

local api = vim.api

local function term(s)
  return api.nvim_replace_termcodes(s, true, false, true)
end

local M = {}

M.pairs = {}

for _, pair in ipairs(these_pairs) do
  M.pairs[pair[1]] = pair[2]
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

M.mapping_same = function (delim)
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  local line = api.nvim_get_current_line()
  if delim == line:sub(col+1,col+1) then
    return term('<C-g>U<Right>')
  else
    return term(string.format('%s%s<C-g>U<Left>', delim, delim))
  end
end

M.mapping_cr = function ()
  if vim.fn.pumvisible() == 1 then
    local cmp = require('cmp')
    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
  else
    local line = api.nvim_get_current_line()
    local pos = api.nvim_win_get_cursor(0)
    local col = pos[2]
    local right = M.pairs[line:sub(col,col)]
    if right == line:sub(col+1,col+1) then
      api.nvim_feedkeys(term('<CR><Esc>O'), 'n', true)
    else
      api.nvim_feedkeys(term('<CR>'), 'n', true)
    end
  end
end

M.mapping_bs = function ()
  local line = api.nvim_get_current_line()
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  local before = line:sub(col,col)
  local after = line:sub(col+1,col+1)
  local right = M.pairs[before]
  if right == after then
    return term('<C-g>U<Right><BS><BS>')
  elseif after == ' ' and before == ' ' then
    local rightright = M.pairs[line:sub(col-1,col-1)]
    if rightright == line:sub(col+2,col+2) then
      return term('<C-g>U<Right><BS><BS>')
    end
  elseif line:match('^%s*$') then
    local row = pos[1]
    local lines = api.nvim_buf_get_lines(0, row-2, row+1, false)
    local first = lines[1]
    if first then
      local before = first:sub(#first, #first)
      local right = M.pairs[before]
      if right and lines[3] and lines[3]:match('^%s*%' .. right) then
        return term('<Esc>ddkJxi')
      end
    end
  end
  return term('<BS>')
end

M.mapping_space = function ()
  local line = api.nvim_get_current_line()
  local pos = api.nvim_win_get_cursor(0)
  local col = pos[2]
  local right = M.pairs[line:sub(col,col)]
  if right == line:sub(col+1,col+1) then
    return term('  <C-g>U<Left>')
  else
    return ' '
  end
end

for left, right in pairs(M.pairs) do
  if left ~= right then
    local rhs = left .. right .. '<C-g>U<Left>'
    api.nvim_set_keymap('i', left, rhs, { noremap = true })
    api.nvim_set_keymap('i', right, 'v:lua.auto_pairs.mapping_right("' .. right .. '")', { noremap = true, expr = true })
  else
    local str = nil
    if left:find("'", 1, true) then
      str = string.format('"%s"', left)
    else
      str = string.format("'%s'", left)
    end
    api.nvim_set_keymap('i', left, 'v:lua.auto_pairs.mapping_same(' .. str .. ')', { noremap = true, expr = true })
  end
end

api.nvim_set_keymap('i', '<CR>', '<Cmd>lua auto_pairs.mapping_cr()<CR>', { noremap = true })
api.nvim_set_keymap('i', '<BS>', 'v:lua.auto_pairs.mapping_bs()', { expr = true, noremap = true })
api.nvim_set_keymap('i', '<Space>', 'v:lua.auto_pairs.mapping_space()', { expr = true, noremap = true })

_G.auto_pairs = M
