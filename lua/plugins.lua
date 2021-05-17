return require('packer').startup(function()
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- Editing commands
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Misc normal mode commands
  use 'tpope/vim-unimpaired'

  -- Close parentheses, if blocks, etc. when Enter is pressed
  use 'rstacruz/vim-closer'
  use 'tpope/vim-endwise'

  -- Navigation
  -- Bugs with nvim 0.5: use 'andymass/vim-matchup'
  use 'rhysd/clever-f.vim'
  use 'justinmk/vim-sneak'

  -- GIT {{{

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

  -- Nice interface for vim's tree-shaped undo
  use 'mbbill/undotree'

  -- Pretty status line
  use 'itchyny/lightline.vim'

  -- Fancy startup screen with sessions and mru etc.
  use 'mhinz/vim-startify'

  -- Faster folds, I guess
  use 'konfekt/fastfold'

  -- Colour schemes
  use 'morhetz/gruvbox'

  -- .editorconfig support
  use 'editorconfig/editorconfig-vim'

  -- Language support
  use 'neovimhaskell/haskell-vim'
  use 'StanAngeloff/php.vim'
  use 'pangloss/vim-javascript'
  use 'leafgarland/typescript-vim'
  use 'peitalin/vim-jsx-typescript'
  use 'elzr/vim-json'

  -- Language server configuration
  use 'neovim/nvim-lspconfig'
end)

-- vim:foldmethod=marker
