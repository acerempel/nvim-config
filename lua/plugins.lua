return require('packer').startup(function()
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- ENHANCEMENTS to the basic Vim experience {{{

  -- Editing-oriented normal mode commands
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Misc normal mode commands
  use 'tpope/vim-unimpaired'

  -- Close parentheses, if blocks, etc. when Enter is pressed
  use 'rstacruz/vim-closer'

  -- Show available keybindings as you type
  use {
    'folke/which-key.nvim',
    config = function ()
      require('which-key').setup {}
    end
  }

  -- Navigation
  use 'andymass/vim-matchup'
  use 'rhysd/clever-f.vim'
  use 'justinmk/vim-sneak'

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
  use 'rhysd/git-messenger.vim'

  -- Show diff when writing a commit message
  use 'rhysd/committia.vim'

  -- Show signs indicating which lines have been changed
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup{}
    end
  }

  -- }}}

  -- EXTRA FEATURES {{{

  -- Tree-sitter language grammars
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function ()
      vim.cmd 'TSUpdate'
    end,
    config = function ()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true},
      }
    end
  }

  -- Fuzzy finder
  use {
    'liuchengxu/vim-clap',
    run = function () vim.cmd 'Clap install-binary' end,
    setup = function ()
      vim.g.clap_theme = 'material_design_dark'
      vim.api.nvim_set_keymap('n', '<Leader>ff', '<Cmd>Clap files<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>fi', '<Cmd>Clap filer<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>fb', '<Cmd>Clap buffers<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>fg', '<Cmd>Clap grep2<CR>', { noremap = true })
    end,
  }

  -- Nice interface for vim's tree-shaped undo
  use 'mbbill/undotree'

  -- Fancy startup screen with sessions and mru etc.
  use {
    'mhinz/vim-startify',
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
  use 'itchyny/lightline.vim'

  -- Colour schemes
  use 'lifepillar/vim-gruvbox8'
  use 'bluz71/vim-nightfly-guicolors'
  use 'ishan9299/nvim-solarized-lua'
  use 'folke/tokyonight.nvim'

  -- }}}

  -- LANGUAGE support {{{

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

  use {
    'vimwiki/vimwiki',
    opt = true
  }

  -- Language server configuration
  use 'neovim/nvim-lspconfig'

  -- Nice UI over built-in language client
  use 'glepnir/lspsaga.nvim'
  use 'ray-x/lsp_signature.nvim'

  -- Autocomplete
  use 'acerempel/nvim-compe'

  -- Snippets
  use 'hrsh7th/vim-vsnip'
  use 'rafamadriz/friendly-snippets'

  -- }}}
end)

-- vim:foldmethod=marker
