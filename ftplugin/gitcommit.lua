-- Better textwidth – override builtin ftplugin
vim.opt_local.textwidth = 67
local api = vim.api
-- if api.nvim_win_get_position(0)[1] > 1 then
--   buf_height = vim.fn.getbufinfo(0).linecount
--   api.nvim_win_set_height(0, buf_height)
-- end
api.nvim_command 'startinsert'
api.nvim_buf_set_keymap(0, 'n', 'q', '<Cmd>wq<CR>', { noremap = true })
api.nvim_buf_set_keymap(0, 'i', '<D-CR>', '<Cmd>stopinsert<Bar>wq<CR>', { noremap = true })
