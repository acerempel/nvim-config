local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

local lsp_saga = require('lspsaga')
local lsp_hover = require('lspsaga.hover')
local lsp_provider = require('lspsaga.provider')

lsp_saga.init_lsp_saga {
  code_action_prompt = { enable = false },
  finder_action_keys = {
    open = "<CR>", split = "s",
    vsplit = "v", quit = 'q',
    scroll_down = '<C-e>', scroll_up = '<C-y>',
  }
}

local lsp_signature = require('lsp_signature')
local lsp_signature_config = {
  bind = false, -- because we are using lspsaga
  doc_lines = 5,
  use_lspsaga = true,
  handler_opts = { border = "single" },
  decorator = { "**", "**" },
}

local on_attach = function(client, bufnr)
  lsp_signature.on_attach(lsp_signature_config)
  local opts = { noremap=true, silent=true }
  local function buf_set_keymap(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end
  buf_set_keymap('n', 'K', "<Cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>")
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_set_keymap('n', '<Leader>ji', "<Cmd>lua require'lspsaga.provider'.lsp_finder()<CR>")
  buf_set_keymap('n', '<Leader>jp', "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>")
  buf_set_keymap('n', '<C-e>', "<Cmd>lua require'lspsaga.action'.smart_scroll_with_saga(1)<CR>")
  buf_set_keymap('n', '<C-y>', "<Cmd>lua require'lspsaga.action'.smart_scroll_with_saga(-1)<CR>")
  buf_set_keymap('n', '[w', "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>")
  buf_set_keymap('n', ']w', "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;

local basic_lsp_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.intelephense.setup {
  root_dir = util.root_pattern("composer.json"),
  on_attach = on_attach,
  capabilities = capabilities,
}
local servers = { "rust_analyzer", "tsserver", "hls", "elmls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup(basic_lsp_config)
end
