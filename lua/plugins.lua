return require('packer').startup(function()
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- Editing commands
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Misc normal mode commands
  use 'tpope/vim-unimpaired'

  -- Navigation
  use 'andymass/vim-matchup'
  use 'rhysd/clever-f.vim'
  use 'justinmk/vim-sneak'

  -- Git commands
  use 'tpope/fugitive'

  -- Nice interface for vim's tree-shaped undo
  use 'mbbill/undotree'

  -- Show diff when writing a commit message
  use 'rhysd/committia.vim'

  -- Pretty status line
  use 'itchyny/lightline.vim'

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
end)
