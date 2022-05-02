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

vim.g.Illuminate_delay = 450

local on_attach = function(client, bufnr)
  require('lsp_signature').on_attach(lsp_signature_config)
  local capabilities = client.server_capabilities
  if capabilities.documentHighlightProvider then
    require('illuminate').on_attach(client)
    vim.keymap.set({'n', 'i'}, '<D-g>', function() require"illuminate".next_reference{wrap=true} end, { buffer = bufnr })
    vim.keymap.set({'n', 'i'}, '<S-D-g>', function() require"illuminate".next_reference{wrap=true,reverse=true} end, { buffer = bufnr })
  end
  local whichkey = require('which-key')
  whichkey.register(
    {
      ["K"] = {
        "<Cmd>lua vim.lsp.buf.hover()<CR>",
        "Show documentation for symbol"
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
  vim.keymap.set({'n', 'i'}, "<Plug>(search-document)", require('telescope.builtin').lsp_document_symbols, { buffer = bufnr })
  vim.keymap.set({'n', 'i'}, "<Plug>(search-workspace)", require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = bufnr })
  if capabilities.documentFormattingProvider then
    vim.keymap.set({'n', 'i'}, '<D-k>f', function() vim.lsp.formatting() end, { buffer = bufnr })
  end
  if capabilities.documentRangeFormattingProvider then
    vim.api.nvim_buf_set_var(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  end
  if capabilities.codeActionProvider then
    vim.keymap.set({'n', 'i'}, '<D-.>', function() vim.lsp.buf.code_action() end, { buffer = bufnr })
    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
      buffer = bufnr,
      callback = function() require'nvim-lightbulb'.update_lightbulb() end,
    })
  end
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
  format = {
    enable = true,
    defaultConfig = {
      indent_style = "space",
      indent_size = "2",
    }
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
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    },
  }
}

local servers = {
  "rust_analyzer", "tsserver",
  "intelephense", "html", "cssls", "jsonls",
  "tailwindcss", "vimls", "sumneko_lua",
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
  if server ~= 'rust_analyzer' then
    lspconfig[server].setup(lsp_config)
  end
end

require('rust-tools').setup({
  tools = {
    inlay_hints = {
      show_parameter_hints = false
    },
  },
  server = lsp_config,
})

require('fidget').setup()

require('nvim-lightbulb').setup {
  sign = { enabled = false },
  virtual_text = { enabled = true },
}
