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

return M
