local whichkey = require('which-key')

local harpoons = {
  name = "Buffers: harpoon",
  a = {
    "<Cmd>lua require'harpoon.mark'.add_file()<CR>",
    "Add to harpoon list"
  },
  e = {
    "<Cmd>lua require'harpoon.ui'.toggle_quick_menu()<CR>",
    "Edit harpoon list"
  },
  [','] = {
    "<Cmd>lua require('telescope').extensions.marks()<CR>",
    "Fuzzy find"
  }
}

for i = 1, 9, 1 do
  harpoons[tostring(i)] = {
    string.format("<cmd>lua require'harpoon.ui'.nav_file(%d)<CR>", i),
    "Go to Nth harpooned buffer"
  }
end

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
      r = {
        "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
        "Frequently & recently used files"
      }
    },
    j = {
      name = "Buffers",
      j = {
        "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })<cr>",
        "Fuzzy find"
      },
      d = { "<cmd>BufferClose<CR>", "Delete bufffer" },
      p = { "<cmd>BufferPin<CR>", "Pin buffer" },
      k = { "<cmd>BufferPick<CR>", "Jump to buffer" },
      c = {
        "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true, cwd_only = true })<cr>",
        "Fuzzy find within current directory"
      },
    },
    d = {
      name = "Directories",
      r = {
        "<Cmd>lua require('telescope').extensions.zoxide.list({})<CR>",
        "Frequently used directories"
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
    S = {
      "<Cmd>lua require('session-lens').search_session()<CR>",
      "Find session"
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
    y = {
      "<cmd>lua require('telescope').extensions.neoclip.default()<CR>",
      "Yank history"
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
  ih = { "Git change-hunk" }
}

whichkey.register(textobjects, { mode = "o" })
whichkey.register(textobjects, { mode = "x" })

whichkey.register(
  {
    [','] = harpoons,
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
      j = { "<Cmd>BufferPrevious<CR>", "Previous buffer" },
      J = { "<Cmd>bfirst<CR>", "First buffer" },
      t = { "<Cmd>tabprev<CR>", "Previous tab" },
      T = { "<Cmd>tabfirst<CR>", "First tab" },
      z = { "Start of current fold" },
      q = { "<Cmd>cbefore<CR>", "Previous quickfix item" },
      Q = { "<Cmd>cfirst<CR>", "First quickfix item" },
      l = { "<Cmd>lbefore<CR>", "Previous loclist item" },
      L = { "<Cmd>lfirst<CR>", "First loclist item" },
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
      j = { "<Cmd>BufferNext<CR>", "Next buffer" },
      J = { "<Cmd>BufferLast<CR>", "Last buffer" },
      t = { "<Cmd>tabnext<CR>", "Next tab" },
      T = { "<Cmd>tablast<CR>", "Last tab" },
      z = { "End of current fold" },
      q = { "<Cmd>cafter<CR>", "Next quickfix item" },
      Q = { "<Cmd>clast<CR>", "Last quickfix item" },
      l = { "<Cmd>lafter<CR>", "Next loclist item" },
      L = { "<Cmd>llast<CR>", "Last loclist item" },
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
