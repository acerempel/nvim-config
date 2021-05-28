local whichkey = require('which-key')

whichkey.register(
  {
    f = {
      name = "Find files from various lists",
      f = {
        "<cmd>lua require('telescope.builtin').find_files()<cr>",
        "Find files in the current directory"
      },
      b = {
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "Find from among open buffers"
      },
      i = {
        "<cmd>lua require('telescope.builtin').file_browser()<cr>",
        "Open a file browser"
      },
      h = {
        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
        "Find help files by tag"
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
