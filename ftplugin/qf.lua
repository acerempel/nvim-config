vim.opt_local.wrap = true
vim.opt_local.linebreak = true

local function map(lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, '', lhs, rhs, { noremap = true })
end

if vim.fn.win_gettype() == "quickfix" then
  map('{', '<Cmd>cpfile<CR>')
  map('}', '<Cmd>cnfile<CR>')
  map('(', '<Cmd>cprev<CR>')
  map(')', '<Cmd>cnext<CR>')
  map('<D-]>', '<Cmd>cnewer<CR>')
  map('<D-[>', '<Cmd>colder<CR>')
  map('<C-I>', '<Cmd>cnewer<CR>')
  map('<C-O>', '<Cmd>colder<CR>')
else
  map('{', '<Cmd>lpfile<CR>')
  map('}', '<Cmd>lnfile<CR>')
  map('(', '<Cmd>lprev<CR>')
  map(')', '<Cmd>lnext<CR>')
  map('<D-]>', '<Cmd>lnewer<CR>')
  map('<D-[>', '<Cmd>lolder<CR>')
  map('<C-I>', '<Cmd>lnewer<CR>')
  map('<C-O>', '<Cmd>lolder<CR>')
end

map('t', '<C-W><CR><C-W>T')
map('s', '<C-W><CR>')
map('v', '<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p')
map('o', '<CR><C-W>p')
vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<CR>', { noremap = true })

vim.api.nvim_command [[command! -nargs=0 -buffer Cedit lua require('replacer').run()]]
vim.api.nvim_command [[cnoreabbrev <buffer> e Cedit]]
