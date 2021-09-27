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
      name = "Current hunk of git changes",
      p = { "Preview diff" },
      r = { "Restore from the index" },
      s = { "Stage" },
      u = { "Undo stage" },
      b = { "Show last commit affecting this line" },
      B = { "<Plug>(git-messenger)", "Show last commit affecting this line, more detail" },
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
        "<Plug>(coc-diagnostic-prev)",
        "Previous diagnostic"
      },
      c = { "Previous Git change" },
      b = { "Previous buffer" },
      B = { "First buffer" },
      t = { "<Cmd>tabprev<CR>", "Previous tab" },
      T = { "<Cmd>tabfirst<CR>", "First tab" },
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
        "<Plug>(coc-diagnostic-next)",
        "Next diagnostic"
      },
      c = { "Next Git change" },
      b = { "Next buffer" },
      B = { "Last buffer" },
      t = { "<Cmd>tabnext<CR>", "Next tab" },
      T = { "<Cmd>tablast<CR>", "Last tab" },
    },
    g = {
      name = "Go to; jump around; select",
      s = { "Select syntax node under cursor" },
      c = { "Comment" },
      t = { "Go to type definition" },
      r = { "Show references" },
      i = { "Go to implementation" },
      O = { "Show document outline" },
      o = { "Go to nth byte" },
    },
    Y = { "Yank till end of line" },
    Q = { "Re-run last used macro" },
    U = { "Show/hide undo tree" },
    Z = { "Delete without register" },
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
