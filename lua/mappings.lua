local whichkey = require('which-key')

whichkey.register(
  {
    b = {
      name = "Buffers",
      f = {
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "Fuzzy find"
      },
      a = { "Add to harpoon list" },
      e = { "Edit harpoon list" },
      b = { "Go to Nth harpooned buffer" },
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
      name = "Symbol under the cursor",
    },
    h = {
      name = "Git operations",
      p = { "Preview hunk diff" },
      r = { "Restore hunk from the index" },
      R = { "Restore all hunks from the index" },
      s = { "Stage hunk" },
      S = { "Stage buffer" },
      u = { "Undo stage hunk" },
      U = { "Restore buffer from the index" },
      b = { "Show last commit affecting this line" },
      B = { "<Plug>(git-messenger)", "Show last commit affecting this line, more detail" },
    },
  },
  { prefix = "<Leader>" }
)

whichkey.register(
  { h = {
    name = "Git operations",
    s = "Stage hunks",
    r = "Restore hunks from the index",
  } },
  { prefix = "<Leader>", mode = "v" }
)

local textobjects = {
  ih = { "Git change hunk" }
}

whichkey.register(textobjects, { mode = "o" })
whichkey.register(textobjects, { mode = "x" })

whichkey.register(
  {
    ["["] = {
      name = "Previous, before, above",
      w = {
        "<Cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit='Warning'})<CR>",
        "Previous warning or error"
      },
      e = {
        "<Cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit='Error'})<CR>",
        "Previous error"
      },
      d = {
        "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
        "Previous diagnostic"
      },
      c = { "Previous Git change" },
      b = { "<Cmd>bprevious<CR>", "Previous buffer" },
      B = { "<Cmd>bfirst<CR>", "First buffer" },
      t = { "<Cmd>tabprev<CR>", "Previous tab" },
      T = { "<Cmd>tabfirst<CR>", "First tab" },
      z = { "Start of current fold" },
    },
    ["]"] = {
      name = "Next, after, below",
      w = {
        "<Cmd>lua vim.lsp.diagnostic.goto_next({severity_limit='Warning'})<CR>",
        "Next warning or error"
      },
      e = {
        "<Cmd>lua vim.lsp.diagnostic.goto_next({severity_limit='Error'})<CR>",
        "Next error"
      },
      d = {
        "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        "Next diagnostic"
      },
      c = { "Next Git change" },
      b = { "<Cmd>bnext<CR>", "Next buffer" },
      B = { "<Cmd>blast<CR>", "Last buffer" },
      t = { "<Cmd>tabnext<CR>", "Next tab" },
      T = { "<Cmd>tablast<CR>", "Last tab" },
      z = { "End of current fold" },
    },
    g = {
      name = "Go to; jump around; select",
      s = { "Select syntax node under cursor" },
      t = { "Go to type definition" },
      r = { "Show references" },
      i = { "Go to implementation" },
      O = { "Show document outline" },
      b = { "go", "Go to nth byte" },
    },
    Y = { "Yank till end of line" },
    Q = { "Re-run last used macro" },
    U = { "Show/hide undo tree" },
    ZZ = { "Delete line without register" },
    z = {
      name = "folds",
      n = { "Turn off folding" },
      N = { "Turn on folding" },
      i = { "Toggle folding" },
      j = { "To start of next fold" },
      k = { "To end of previous fold" },
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
