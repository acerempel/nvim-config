_G.check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

_G.term = function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

return require('packer').startup(function()
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- ENHANCEMENTS to the basic Vim experience {{{

  -- Editing-oriented normal mode commands
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use { 'tpope/vim-commentary', cond = function() return vim.g.vscode == nil end }

  -- Misc normal mode commands
  use 'tpope/vim-unimpaired'

  -- Improvements to QuickFix and Location List
  use 'romainl/vim-qf'

  -- Cache lua require() calls
  use 'lewis6991/impatient.nvim'

  -- Close parentheses, etc. automatically

  -- Nice interface for vim's tree-shaped undo
  use 'mbbill/undotree'

  -- Show available keybindings as you type
  use {
    'folke/which-key.nvim',
    config = function ()
      require('which-key').setup {
        layout = {
          height = { min = 4, max = 20 }
        },
        operators = {
          gc = "Comment",
          Z = "Delete without register",
        },
      }
    end
  }

  -- Navigation
  use 'andymass/vim-matchup'
  use 'rhysd/clever-f.vim'
  use 'justinmk/vim-sneak'

  -- Show register contents
  use 'gennaro-tedesco/nvim-peekup'

  -- Fix performance issues with the CursorHold autocmd
  use {
    'antoinemadec/FixCursorHold.nvim',
    run = function ()
      vim.g.cursorhold_updatetime = 700
    end
  }

  -- }}}

  -- GIT integration {{{

  -- Show the commit message for the last commit affecting this line
  use { 'rhysd/git-messenger.vim', cond = function() return vim.g.vscode == nil end }

  -- Show diff when writing a commit message
  use 'rhysd/committia.vim'

  -- Show signs indicating which lines have been changed
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    cond = function() return vim.g.vscode == nil end,
    config = function()
      require('gitsigns').setup{}
    end
  }

  -- }}}

  -- EXTRA FEATURES {{{

  use {
    'nvim-telescope/telescope.nvim',
    cond = function() return vim.g.vscode == nil end,
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    config = function ()
      local telescope = require('telescope')
      telescope.setup()
      telescope.load_extension('fzy_native')
    end
  }

  use {
    'folke/trouble.nvim',
    cond = function() return vim.g.vscode == nil end,
    config = function ()
      require("trouble").setup {
        icons = false
      }
    end
  }

  use {
    'sindrets/diffview.nvim',
    cmd = 'DiffviewOpen',
    cond = function() return vim.g.vscode == nil end,
    config = function ()
      require('diffview').setup {
        use_icons = false,
      }
    end
  }

  -- Fancy startup screen with sessions and mru etc.
  use {
    'mhinz/vim-startify',
    cond = function() return vim.g.vscode == nil end,
    setup = function ()
      vim.g.startify_custom_header_quotes = require('quotes')
    end
  }

  -- Faster folds, I guess
  use 'konfekt/fastfold'

  -- .editorconfig support
  use 'editorconfig/editorconfig-vim'

  use 'chrisbra/unicode.vim'

  -- }}}

  -- AESTHETICS {{{

  -- Pretty status line
  use {
    'hoob3rt/lualine.nvim',
    config = function ()
      require('statusline').setup()
    end
  }

  use {
    'ThePrimeagen/harpoon',
    config = function () require('harpoon').setup {} end,
  }

  -- Colour schemes
  use 'lifepillar/vim-gruvbox8'
  use 'bluz71/vim-nightfly-guicolors'
  use 'ishan9299/nvim-solarized-lua'
  use 'folke/tokyonight.nvim'

  -- }}}

  use {
    'vimwiki/vimwiki',
    opt = true
  }

  -- LANGUAGE support {{{

  -- Syntax knowledge, incl. tree-sitter {{{

  -- Syntax highlighting and suchlike
  use 'neovimhaskell/haskell-vim'
  use {
    'gabrielelana/vim-markdown',
    setup = function ()
      vim.g.markdown_enable_mappings = 0
      vim.g.markdown_enable_input_abbreviations = 0
      vim.g.markdown_enable_insert_mode_mappings = 1
    end,
  }

  -- Tree-sitter language grammars
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    cond = function() return vim.g.vscode == nil end,
    run = function ()
      vim.cmd 'TSUpdate'
    end,
    config = function ()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gs",
            node_incremental = "gn",
            scope_incremental = "go",
            node_decremental = "gN",
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
        }
      }
    end
  }

  use 'nvim-treesitter/playground'

  -- }}}

  -- Semantic knowledge, incl. LSP {{{

  -- }}}

  -- Keystroke-saving, incl. completion {{{

  use {
    'L3MON4D3/LuaSnip',
    config = function ()
      local types = require('luasnip.util.types')
      _G.luasnip = require('luasnip')
      luasnip.config.set_config({
        history = true,
        -- Update more often, :h events for more info.
        updateevents = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "choiceNode", "Comment" } },
            },
          },
        },
        -- treesitter-hl has 100, use something higher (default is 200).
        ext_base_prio = 300,
        -- minimal increase in priority.
        ext_prio_increase = 1,
      })
      _G.mapping_ctrl_n = function ()
        if luasnip.choice_active() then
          return term('<Cmd>lua luasnip.change_choice(1)<CR>')
        else
          return term('<C-n>')
        end
      end
      _G.mapping_ctrl_p = function ()
        if luasnip.choice_active() then
          return term('<Cmd>lua luasnip.change_choice(-1)<CR>')
        else
          return term('<C-p>')
        end
      end
      vim.api.nvim_set_keymap("i", "<C-n>", "v:lua.mapping_ctrl_n()", { expr = true, noremap = true })
      vim.api.nvim_set_keymap("s", "<C-n>", "v:lua.mapping_ctrl_n()", { expr = true, noremap = true })
      vim.api.nvim_set_keymap("i", "<C-p>", "v:lua.mapping_ctrl_p()", { expr = true, noremap = true })
      vim.api.nvim_set_keymap("s", "<C-p>", "v:lua.mapping_ctrl_p()", { expr = true, noremap = true })
      vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-expand-or-jump", {})
      vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-expand-or-jump", {})
      vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-jump-prev", {})
      vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-jump-prev", {})
    end
  }

  -- Autocomplete

  use {
    'hrsh7th/nvim-cmp',
    disable = true,
    requires = {
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
    },
    after = { 'LuaSnip' },
    config = function ()
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        completion = {
          autocomplete = false,
          completeopt = 'menu,menuone,noselect',
        },
        mapping = {
          -- Pears handles this now
          -- ['<CR>'] = cmp.mapping.confirm({select = true}),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(term('<C-n>'), 'n', true)
              elseif check_back_space() then
                fallback()
                -- vim.api.nvim_feedkeys(term('<Tab>'), 'n', true)
              else
                cmp.complete()
              end
            end,
          ['<S-Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(term('<C-p>'), 'n', true)
              else
                fallback()
                -- vim.api.nvim_feedkeys(term('<S-Tab>'), 'n', true)
              end
            end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
        },
        experimental = {
          ghost_text = true,
        },
      }
    end
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    cond = function () return vim.g.vscode == nil end,
  }

  -- }}}

  -- }}}
end)

-- vim:foldmethod=marker
