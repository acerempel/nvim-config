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
    p = {
      "<cmd>lua require('telescope.builtin').find_files()<cr>",
      "Files beneath the current directory"
    },
    h = {
      "<cmd>lua require('telescope.builtin').help_tags()<cr>",
      "Help tags"
    },
    i = {
      "<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>",
      "Directory tree"
    },
    o = {
      "<cmd>lua require('telescope.builtin').oldfiles()<cr>",
      "Files from previous sessions"
    },
    f = {
      "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
      "Frequently & recently used files"
    },
    a = {
      "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })<cr>",
      "Buffers"
    },
    j = {
      name = "Buffers",
      d = { "<cmd>BufferClose<CR>", "Delete bufffer" },
      k = { "<cmd>BufferLinePick<CR>", "Jump to buffer" },
      c = {
        "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true, cwd_only = true })<cr>",
        "Fuzzy find within current directory"
      },
    },
    d = {
      "<Cmd>lua require('telescope').extensions.zoxide.list({})<CR>",
      "Frequently used directories"
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
    s = {
      "<Cmd>lua require('session-lens').search_session()<CR>",
      "Find session"
    },
    c = {
      name = "Git: change-hunk actions",
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
    --[[ y = {
      "<cmd>lua require('telescope').extensions.neoclip.default()<CR>",
      "Yank history"
    }, ]]
  },
  { prefix = "<Leader>" }
)

local textobjects = {
  ih = { "Git change-hunk" }
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
      j = { "<Cmd>BufferLineCycleNext<CR>", "Next buffer" },
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
      W = {
        "<cmd>lua require'telescope.builtin'.live_grep({ additional_args = '-F' })<CR>",
        "Search for regex"
      }
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
    },
    [','] = {
      name = 'Fuzzy find',
      d = {
        "<Cmd>lua require('telescope').extensions.zoxide.list({ disable_devicons = true })<CR>",
        "Directories oft-used"
      },
      f = {
        "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
        "Files oft-used"
      },
      h = {
        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
        "Help tags"
      },
      m = {
        "<cmd>lua require('telescope.builtin').man_pages()<cr>",
        "Man pages"
      },
      s = {
        "<cmd>lua require('telescope.builtin').buffers()<CR>",
        "Buffers"
      },
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
