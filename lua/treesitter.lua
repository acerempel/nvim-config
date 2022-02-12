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
  textsubjects = {
    enable = true,
    keymaps = {
      ['\\'] = 'textsubjects-smart',
      ['`'] = 'textsubjects-container-outer',
    }
  },
}
