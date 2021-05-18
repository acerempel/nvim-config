local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
end

lspconfig.intelephense.setup {
  root_dir = util.root_pattern("composer.json"),
  on_attach = on_attach,
}

lspconfig.rust_analyzer.setup {
  on_attach = on_attach
}
