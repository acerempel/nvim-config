require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
  matchup = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<M-o>",
      node_incremental = "<M-o>",
      scope_incremental = "<S-M-o>",
      node_decremental = "<M-i>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        af = "@function.outer",
        ['if'] = "@function.inner",
        ic = "@call.inner",
        ac = "@call.outer",
        iC = "@class.inner",
        aC = "@class.outer",
        ia = "@parameter.inner",
        aa = "@parameter.outer",
        ['i/'] = "@comment.inner",
        ['a/'] = "@comment.outer",
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
        ["]/"] = "@comment.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[/"] = "@comment.outer",
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
    prev_selection = '_',
    keymaps = {
      ['+'] = 'textsubjects-smart',
      ['<Leader>as'] = 'textsubjects-container-outer',
      ['<Leader>is'] = 'textsubjects-container-inner',
    }
  },
}

require('nvim-treesitter.install').compilers = { "gcc" }

vim.keymap.set('n', '+', 'v)', {remap = true})
