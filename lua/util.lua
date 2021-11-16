M = {}

M.term = function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

M.is_not_vscode = function() return vim.g.vscode == nil end

M.check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

M.get_line_to_cursor = function ()
  local line = vim.api.nvim_get_current_line()
  local _, col = unpack(vim.api.nvim_win_get_cursor())
  return line:sub(1, col)
end

return M
