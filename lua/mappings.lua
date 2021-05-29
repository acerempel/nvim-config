local whichkey = require('which-key')

whichkey.register(
  {
    f = {
      name = "Find files from various lists",
      f = {
        "<cmd>lua require('telescope.builtin').find_files()<cr>",
        "Files beneath the current directory"
      },
      b = {
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "Open buffers"
      },
      i = {
        "<cmd>lua require('telescope.builtin').file_browser()<cr>",
        "Directory tree"
      },
      h = {
        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
        "Help tags"
      },
      o = {
        "<cmd>lua require('telescope.builtin').oldfiles()<cr>",
        "Files from previous sessions"
      },
    },
    k = {
      name = "Show information about the symbol under the cursor",
      d = {
        "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>",
        "Show definition in a pop-up window"
      },
      i = {
        "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>",
        "List definition and references, with preview"
      },
      a = {
        "<cmd>lua require'lspsaga.codeaction'.code_action()<CR>",
        "Show available code actions"
      },
    },
    h = {
      name = "Current hunk of git changes",
      p = { "Preview diff" },
      r = { "Restore from the index" },
      s = { "Stage" },
      u = { "Undo stage" },
    },
  },
  { prefix = "<Leader>" }
)

whichkey.register(
  {
    ["["] = {
      name = "Previous, before, above",
      w = {
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev({severity_limit='Warning'})<CR>",
        "Previous warning or error"
      },
      j = {
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev({severity_limit='Error'})<CR>",
        "Previous error"
      },
      d = {
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>",
        "Previous diagnostic"
      },
      c = { "Previous Git change" },
    },
    ["]"] = {
      name = "Next, after, below",
      w = {
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next({severity_limit='Warning'})<CR>",
        "Next warning or error"
      },
      j = {
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next({severity_limit='Error'})<CR>",
        "Next error"
      },
      d = {
        "<Cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>",
        "Next diagnostic"
      },
      c = { "Next Git change" },
    },
    g = {
      name = "Go to; selection manipulation",
      s = { "Select syntax node under cursor" },
      c = { "Comment" },
    }
  }
)

whichkey.register(
  {
    g = {
      n = { "Extend the selection to the enclosing node" },
      m = { "Extend the selection to the enclosing scope" },
      N = { "Intend the selection to the enclosed node" },
    }
  },
  { mode = "v" }
)
