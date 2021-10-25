require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "-",
      node_incremental = "-",
      scope_incremental = "+",
      node_decremental = "_",
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        af = "@function.outer",
        ['if'] = "@function.inner",
        ic = "@call.inner",
        ac = "@call.outer",
        iC = "@class.inner",
        aC = "@class.outer",
        iP = "@parameter.inner",
        ib = "@block.inner",
        ab = "@block.outer",
      }
    },
    move = {
      enable = true,
      set_jump = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    }
  },
  lsp_interop = {
    enable = true,
    border = "rounded",
    peek_definition_code = {
      ["<Leader>kf"] = "@function.outer",
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textsubjects = {
    enable = true,
    keymaps = {
      [';'] = 'textsubjects-smart',
      [','] = 'textsubjects-container-outer',
    }
  },
}
