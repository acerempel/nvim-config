local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

local lsp_signature = require('lsp_signature')
local lsp_signature_config = {
  bind = true,
  doc_lines = 5,
  max_width = 80,
  handler_opts = { border = "single" },
  decorator = { "**", "**" },
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { max_width = 80, border = 'single', }
)

local on_attach = function(client, bufnr)
  lsp_signature.on_attach(lsp_signature_config)
  vim.api.nvim_command [[
    au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  ]]
  local whichkey = require('which-key')
  whichkey.register(
    {
      ["K"] = {
        "<Cmd>lua vim.lsp.buf.hover()<CR>",
        "Show documentation for the symbol under the cursor"
      },
      ["gO"] = {
        "<Cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>",
        "Show document outline"
      },
      ["gW"] = {
        "<Cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<CR>",
        "Show all workspace symbols"
      },
      ["gd"] = {
        "<Cmd>lua vim.lsp.buf.definition()<CR>",
        "Go to definition"
      },
      ["gD"] = {
        "<Cmd>lua vim.lsp.buf.declaration()<CR>",
        "Go to declaration"
      },
      ["<Leader>kr"] = {
        "<Cmd>lua vim.lsp.buf.rename()<CR>",
        "Rename the identifier under the cursor"
      },
      ["<Leader>ka"] = {
        "<Cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>",
        "Show available code actions"
      },
      ["<Leader>kh"] = {
        "<Cmd>lua vim.lsp.buf.document_highlight()<CR>",
        "Highlight occurrences"
      },
      ["gR"] = {
        "<Cmd>Trouble lsp_references<CR>",
        "Show references to the current symbol"
      }
    },
    { buffer = bufnr }
  )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

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
