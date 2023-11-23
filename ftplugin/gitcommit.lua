-- Better textwidth – override builtin ftplugin
vim.opt_local.textwidth = 67
local api = vim.api
api.nvim_command 'startinsert'
api.nvim_buf_set_keymap(0, 'i', '<D-CR>', '<Cmd>stopinsert<Bar>wq<CR>', { noremap = true })
api.nvim_buf_set_keymap(0, 'i', '<C-CR>', '<Cmd>stopinsert<Bar>wq<CR>', { noremap = true })
vim.wo.spell = true
