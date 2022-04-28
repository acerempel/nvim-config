local lspconfig = require('lspconfig')

local lsp_signature_config = {
  bind = true,
  doc_lines = 5,
  max_width = 80,
  handler_opts = { border = "single" },
  decorator = { "**", "**" },
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { max_width = 72, }
)

local on_attach = function(client, bufnr)
  require('lsp_signature').on_attach(lsp_signature_config)
  vim.cmd(string.format([[
    augroup lsp_buf
    au!
    au CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()
    au InsertLeave,BufEnter,BufWritePost <buffer=%d> lua require('symbols-outline')._refresh()
    augroup END
  ]], bufnr, bufnr))
  local whichkey = require('which-key')
  whichkey.register(
    {
      ["K"] = {
        "<Cmd>lua vim.lsp.buf.hover()<CR>",
        "Show documentation for symbol"
      },
      ["go"] = {
        "<Cmd>lua vim.lsp.buf.document_symbol()<CR>",
        "Search document symbols"
      },
      ["gO"] = {
        "<Cmd>lua require'symbols-outline'.toggle_outline()<CR>",
        "Show document outline"
      },
      ["gW"] = {
        "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
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
        "Rename symbol"
      },
      ["gh"] = {
        "<Cmd>lua vim.lsp.buf.document_highlight()<CR>",
        "Highlight occurrences"
      },
      ["gt"] = {
        "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
        "Go to type definition"
      },
      ["g]"] = {
        "<Cmd>lua vim.lsp.buf.references()<CR>",
        "Search references to symbol"
      },
      ['z='] = {
        "<Cmd>lua vim.lsp.buf.code_action()<CR>",
        "Code actions"
      },
    },
    { buffer = bufnr }
  )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lua_config = {
  runtime = {
    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
    version = 'LuaJIT',
    -- Setup your lua path
    path = runtime_path,
  },
  diagnostics = {
    -- Get the language server to recognize the `vim` global
    globals = {'vim'},
  },
  workspace = {
    -- Make the server aware of Neovim runtime files
    library = vim.api.nvim_get_runtime_file("", true),
  },
  -- Do not send telemetry data containing a randomized but unique identifier
  telemetry = {
    enable = false,
  },
}

local lsp_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    intelephense = { stubs = { "wordpress", "standard", "pcre", "http", "json", "mysql", "mysqli", "pdo_mysql" } },
    json = {
      schemas = require("schemastore").json.schemas(),
    },
    Lua = lua_config,
  }
}

local servers = {
  "rust_analyzer", "tsserver",
  "intelephense", "html", "cssls", "jsonls",
  "tailwindcss", "vimls",
}

require('nvim-lsp-installer').setup {
  ensure_installed = servers,
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
}

for _, server in ipairs(servers) do
  lspconfig[server].setup(lsp_config)
end
