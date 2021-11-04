vim.opt_local.wrap = true
vim.opt_local.linebreak = true

function map(lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, '', lhs, rhs, { noremap = true })
end

map('{', '<Cmd>lua require("qf_helper").navigate(-vim.v.count1, { by_file = true })<CR>')
map('}', '<Cmd>lua require("qf_helper").navigate(+vim.v.count1, { by_file = true })<CR>')
map('(', '<Cmd>lua require("qf_helper").navigate(-vim.v.count1)<CR>')
map(')', '<Cmd>lua require("qf_helper").navigate(+vim.v.count1)<CR>')
map('t', '<C-W><CR><C-W>T')
map('s', '<C-W><CR>')
map('v', '<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p')
map('o', '<CR><C-W>p')

vim.api.nvim_command [[command! -nargs=0 -buffer Cedit lua require('replacer').run()]]
vim.api.nvim_command [[cnoreabbrev <buffer> e Cedit]]
