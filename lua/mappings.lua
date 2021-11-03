local whichkey = require('which-key')

whichkey.register(
  {
    f = {
      name = "Find files",
      f = {
        "<cmd>lua require('telescope.builtin').find_files()<cr>",
        "Files beneath the current directory"
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
      name = "Symbol under the cursor",
    },
    g = {
      name = "Git: worktree actions",
      b = {
        "<cmd>lua require('telescope.builtin').git_branches()<CR>",
        "Switch branch"
      },
    },
    h = {
      name = "Git: change-hunk actions",
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
    [':'] = {
      "<cmd>lua require('telescope.builtin').commands()<CR>",
      "Run Ex command"
    },
    ['*'] = {
      "<cmd>lua require('telescope.builtin').grep_string()<cr>",
      "Search files for word under cursor"
    },
    ['/'] = {
      "<cmd>lua require('telescope.builtin').live_grep()<cr>",
      "Search files using regex"
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
    [';'] = {
      name = "Buffers",
      f = {
        "<cmd>lua require('telescope.builtin').buffers({ show_all_buffers = false, sort_lastused = true })<cr>",
        "Fuzzy find"
      },
      d = {
        "<cmd>lua require('telescope.builtin').buffers({ show_all_buffers = false, sort_lastused = true, cwd_only = true })<cr>",
        "Fuzzy find within current directory"
      },
      a = {
        "<Cmd>lua require'harpoon.mark'.add_file()<CR>",
        "Add to harpoon list"
      },
      e = {
        "<Cmd>lua require'harpoon.ui'.toggle_quick_menu()<CR>",
        "Edit harpoon list"
      },
      [';'] = {
        "<Cmd>lua require'harpoon.ui'.nav_file(vim.v.count1)<CR>",
        "Go to Nth harpooned buffer"
      },
    },
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
      O = { "Show document outline" },
      b = { "go", "Go to nth byte" },
    },
    Y = { "Yank till end of line" },
    Q = { "Re-run last used macro" },
    U = { "Show/hide undo tree" },
    Z = { "Delete without register" },
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
    ['-'] = { "Extend the selection to the enclosing node" },
    ['+'] = { "Extend the selection to the enclosing scope" },
    ['_'] = { "Intend the selection to the enclosed node" },
  },
  { mode = "v" }
)
