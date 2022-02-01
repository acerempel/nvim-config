M = {}

M.term = function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

M.is_not_vscode = function() return vim.g.vscode == nil end

M.check_back_space = function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col == 0 or vim.api.nvim_get_current_line():sub(1, col):match("%s$")
end

M.get_line_to_cursor = function ()
  local line = vim.api.nvim_get_current_line()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  return line:sub(1, col)
end

return M
