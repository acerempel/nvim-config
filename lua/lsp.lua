local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

local lsp_saga = require('lspsaga')
local lsp_hover = require('lspsaga.hover')
local lsp_provider = require('lspsaga.provider')

lsp_saga.init_lsp_saga {
  code_action_prompt = { enable = false },
  finder_action_keys = {
    open = "<CR>", split = "s",
    vsplit = "v", quit = '<Esc>',
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
  local whichkey = require('which-key')
  whichkey.register(
    {
      ["K"] = {
        "<Cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>",
        "Show documentation for the symbol under the cursor"
      },
      ["gO"] = "<Cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>",
      ["gd"] = {
        "<Cmd>lua vim.lsp.buf.definition()<CR>",
        "Go to definition"
      },
      ["<C-e>"] = {
        "<Cmd>lua require'lspsaga.action'.smart_scroll_with_saga(1)<CR>",
        "Scroll down one line"
      },
      ["<C-y>"] = {
        "<Cmd>lua require'lspsaga.action'.smart_scroll_with_saga(-1)<CR>",
        "Scroll up one line"
      },
    },
    { buffer = bufnr }
  )
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
