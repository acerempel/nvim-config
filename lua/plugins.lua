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
  use 'tpope/vim-endwise'

  -- Navigation
  use 'andymass/vim-matchup'
  use 'rhysd/clever-f.vim'
  use 'justinmk/vim-sneak'

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

  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup{}
    end
  }

  -- }}}

  -- EXTRA FEATURES {{{

  -- Fuzzy finder
  use {
    'Yggdroot/LeaderF',
    run = function ()
      vim.cmd 'LeaderfInstallCExtension'
    end
  }

  -- Nice interface for vim's tree-shaped undo
  use 'mbbill/undotree'

  -- Fancy startup screen with sessions and mru etc.
  use 'mhinz/vim-startify'

  -- Faster folds, I guess
  use 'konfekt/fastfold'

  -- .editorconfig support
  use 'editorconfig/editorconfig-vim'

  -- }}}

  -- AESTHETICS {{{

  -- Pretty status line
  use 'itchyny/lightline.vim'

  -- Colour schemes
  use 'morhetz/gruvbox'

  -- }}}

  -- LANGUAGE support {{{

  -- Syntax highlighting and suchlike
  use 'neovimhaskell/haskell-vim'
  use 'StanAngeloff/php.vim'
  use 'pangloss/vim-javascript'
  use 'leafgarland/typescript-vim'
  use 'peitalin/vim-jsx-typescript'
  use 'elzr/vim-json'

  -- Language server configuration
  use 'neovim/nvim-lspconfig'

  -- }}}
end)

-- vim:foldmethod=marker
