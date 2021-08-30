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

  -- Close parentheses, etc. automatically
  use 'Raimondi/delimitMate'

  -- Nice interface for vim's tree-shaped undo
  use 'mbbill/undotree'

  -- Show available keybindings as you type
  use {
    'folke/which-key.nvim',
    config = function ()
      require('which-key').setup {
        layout = {
          height = { min = 4, max = 20 }
        }
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
        file_panel = { use_icons = false },
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
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          }
        },
      }
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    cond = function() return vim.g.vscode == nil end
  }

  -- }}}

  -- Semantic knowledge, incl. LSP {{{

  -- Language server configuration
  use { 'neovim/nvim-lspconfig' }

  use 'ray-x/lsp_signature.nvim'

  -- }}}

  -- Keystroke-saving, incl. completion {{{

  -- Autocomplete
  use { 'acerempel/nvim-compe' }

  -- Snippets
  use 'hrsh7th/vim-vsnip'
  use 'rafamadriz/friendly-snippets'

  -- }}}

  -- }}}
end)

-- vim:foldmethod=marker
