-- Better textwidth – override builtin ftplugin
vim.opt_local.textwidth = 67
local api = vim.api
-- if api.nvim_win_get_position(0)[1] > 1 then
--   buf_height = vim.fn.getbufinfo(0).linecount
--   api.nvim_win_set_height(0, buf_height)
-- end
api.nvim_command 'startinsert'
api.nvim_buf_set_keymap(0, 'n', 'q', '<Cmd>wq<CR>', { noremap = true })
local tab_rhs = 'pumvisible() ? "<C-n>" : luaeval("check_back_space()") == v:true ? "<Tab>" : "<C-x><C-o>"'
local s_tab_rhs = 'pumvisible() ? "<C-p>" : "<S-Tab>"'
local cr_rhs = 'pumvisible() ? "<C-y>" : "<Plug>(auto-pairs-cr)"'
local esc_rhs = 'pumvisible() ? "<C-e>" : "<Esc>"'
api.nvim_buf_set_keymap(0, 'i', '<Tab>', tab_rhs, { noremap = true, expr = true })
api.nvim_buf_set_keymap(0, 'i', '<S-Tab>', s_tab_rhs, { noremap = true, expr = true })
api.nvim_buf_set_keymap(0, 'i', '<CR>', cr_rhs, { expr = true })
api.nvim_buf_set_keymap(0, 'i', '<Esc>', esc_rhs, { noremap = true, expr = true })
api.nvim_buf_set_keymap(0, 'i', '<D-CR>', '<Cmd>stopinsert<Bar>wq<CR>', { noremap = true })
