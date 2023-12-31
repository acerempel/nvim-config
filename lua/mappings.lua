local whichkey = require('which-key')

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
    m = {
      "<cmd>lua require('telescope.builtin').man_pages()<CR>",
      "Man pages",
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
      m = {
        "<cmd>Merginal<CR>",
        "Merginal"
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
        "<Cmd>lua vim.diagnostic.goto_prev({severity={min='Warning'}})<CR>",
        "Previous warning or error"
      },
      e = {
        "<Cmd>lua vim.diagnostic.goto_prev({severity={min='Error'}})<CR>",
        "Previous error"
      },
      d = {
        "<Cmd>lua vim.diagnostic.goto_prev()<CR>",
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
        "<Cmd>lua vim.diagnostic.goto_next({severity={min='Warning'}})<CR>",
        "Next warning or error"
      },
      e = {
        "<Cmd>lua vim.diagnostic.goto_next({severity={min='Error'}})<CR>",
        "Next error"
      },
      d = {
        "<Cmd>lua vim.diagnostic.goto_next()<CR>",
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
      O = { "<Plug>(search-document)", "Search document symbols" },
      b = { "go", "Go to nth byte" },
      W = {
        "<Plug>(search-workspace)",
        "Search workspace symbols"
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
