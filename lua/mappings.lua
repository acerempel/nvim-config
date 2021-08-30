local whichkey = require('which-key')

whichkey.register(
  {
    b = {
      name = "Buffers",
      f = {
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "Fuzzy find"
      },
      b = { "Add to harpoon list" },
      e = { "Edit harpoon list" },
    },
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
      g = { "Live grep" },
      s = { "Grep string" },
    },
    k = {
      name = "Show information about the symbol under the cursor",
    },
    h = {
      name = "Current hunk of git changes",
      p = { "Preview diff" },
      r = { "Restore from the index" },
      s = { "Stage" },
      u = { "Undo stage" },
      b = { "Show last commit affecting this line" },
    },
  },
  { prefix = "<Leader>" }
)

whichkey.register(
  {
    ["["] = {
      name = "Previous, before, above",
      w = {
        "<Cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit='Warning'})<CR>",
        "Previous warning or error"
      },
      j = {
        "<Cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit='Error'})<CR>",
        "Previous error"
      },
      d = {
        "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
        "Previous diagnostic"
      },
      c = { "Previous Git change" },
      b = {
        "Previous buffer"
      },
    },
    ["]"] = {
      name = "Next, after, below",
      w = {
        "<Cmd>lua vim.lsp.diagnostic.goto_next({severity_limit='Warning'})<CR>",
        "Next warning or error"
      },
      j = {
        "<Cmd>lua vim.lsp.diagnostic.goto_next({severity_limit='Error'})<CR>",
        "Next error"
      },
      d = {
        "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        "Next diagnostic"
      },
      c = { "Next Git change" },
      b = {
        "Next buffer"
      },
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
