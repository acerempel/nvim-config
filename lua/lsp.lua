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

local highlight = require('lsp.highlight')
local highlight_attach = highlight.setup { wrap = true }

local on_attach = function(client, bufnr)
  require('lsp_signature').on_attach(lsp_signature_config)
  local capabilities = client.server_capabilities
  highlight_attach(bufnr)
  vim.keymap.set('n', 'gh', vim.lsp.buf.document_highlight, { buffer = bufnr })
  vim.keymap.set({'n', 'i'}, '<d-e>', vim.lsp.buf.document_highlight, { buffer = bufnr })
  vim.keymap.set({'n', 'i'}, '<d-g>', function() highlight.next_reference{wrap=true} end, { buffer = bufnr })
  vim.keymap.set({'n', 'i'}, '<s-d-g>', function() highlight.next_reference{wrap=true,reverse=true} end, { buffer = bufnr })
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
  vim.keymap.set({'n', 'x'}, "<C-w><CR>", function() require('goto-preview').goto_preview_definition() end, { buffer = bufnr })
  vim.keymap.set({'n', 'x'}, "<C-w>g]", function() require('goto-preview').goto_preview_references() end, { buffer = bufnr })
  vim.keymap.set({'n', 'i'}, "<Plug>(search-document)", require('telescope.builtin').lsp_document_symbols, { buffer = bufnr })
  vim.keymap.set({'n', 'i'}, "<Plug>(search-workspace)", require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = bufnr })
  if capabilities.documentFormattingProvider then
    vim.keymap.set({'n', 'i'}, '<d-k>f', function() vim.lsp.formatting() end, { buffer = bufnr })
  end
  if capabilities.documentRangeFormattingProvider then
    vim.api.nvim_buf_set_var(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  end
  vim.keymap.set({'n', 'i'}, '<d-.>', function() vim.lsp.buf.code_action() end, { buffer = bufnr })
  vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
    buffer = bufnr,
    callback = function() require'nvim-lightbulb'.update_lightbulb() end,
  })
end

capabilities = require('cmp_nvim_lsp').default_capabilities()

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
    intelephense = { stubs = { "Core", "mbstring", "date", "superglobals", "wordpress", "standard", "pcre", "http", "json", "mysql", "mysqli", "pdo_mysql" } },
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
      hoverActions = {
        enable = false,
      },
    },
  }
}

local servers = {
  "rust_analyzer", "tsserver",
  "intelephense", "html", "cssls", "jsonls",
  "tailwindcss", "vimls", "sumneko_lua",
  "pyright",
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
