local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

lsp_saga = require('lspsaga')
lsp_hover = require('lspsaga.hover')
lsp_provider = require('lspsaga.provider')

lsp_saga.init_lsp_saga {
  code_action_prompt = { enable = false },
  finder_action_keys = {
    open = "o", split = "s",
    vsplit = "v", quit = 'q',
    scroll_down = '<C-e>', scroll_up = '<C-y>',
  }
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'K', "<Cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>", opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>ji', "<Cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", opts)
  buf_set_keymap('n', '<Leader>jp', "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
  buf_set_keymap('n', '<C-e>', "<Cmd>lua require'lspsaga.action'.smart_scroll_with_saga(1)<CR>", opts)
  buf_set_keymap('n', '<C-y>', "<Cmd>lua require'lspsaga.action'.smart_scroll_with_saga(-1)<CR>", opts)
  buf_set_keymap('n', '[w', "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
  buf_set_keymap('n', ']w', "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)
end

lspconfig.intelephense.setup {
  root_dir = util.root_pattern("composer.json"),
  on_attach = on_attach,
}

lspconfig.rust_analyzer.setup { on_attach = on_attach }

lspconfig.tsserver.setup { on_attach = on_attach }
