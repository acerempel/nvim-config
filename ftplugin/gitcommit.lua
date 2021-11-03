-- Better textwidth – override builtin ftplugin
vim.opt_local.textwidth = 67
api = vim.api
if api.nvim_win_get_position(0)[1] > 1 then
  buf_height = vim.fn.getbufinfo(0).linecount
  api.nvim_win_set_height(0, buf_height)
end
