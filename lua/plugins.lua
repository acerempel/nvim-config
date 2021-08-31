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

  use {
    'L3MON4D3/LuaSnip',
    config = function ()
      vim.api.nvim_set_keymap("i", "<C-,>", "<Plug>luasnip-next-choice", {})
      vim.api.nvim_set_keymap("s", "<C-,>", "<Plug>luasnip-next-choice", {})
      vim.api.nvim_set_keymap("i", "<C-.>", "<Plug>luasnip-prev-choice", {})
      vim.api.nvim_set_keymap("s", "<C-.>", "<Plug>luasnip-prev-choice", {})
      vim.api.nvim_set_keymap("i", "<C-;>", "<Plug>luasnip-expand-or-jump", {expr = true})
      vim.api.nvim_set_keymap("s", "<C-;>", "<Plug>luasnip-expand-or-jump", {expr = true})
      vim.api.nvim_set_keymap("i", "<C-'>", "<Plug>luasnip-jump-prev", {expr = true})
      vim.api.nvim_set_keymap("s", "<C-'>", "<Plug>luasnip-jump-prev", {expr = true})
    end
  }

  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
  end

  local term = function(s)
    return vim.api.nvim_replace_termcodes(s, true, true, true)
  end

  -- Autocomplete
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
    },
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
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = {
          ['<CR>'] = cmp.mapping.confirm(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
              elseif check_back_space() then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n')
              else
                fallback()
              end
            end,
          ['<S-Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(term('<C-p>'), 'n')
              else
                vim.api.nvim_feedkeys(term('<S-Tab>'), '')
              end
            end,
        },
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp' },
        },
      }
    end
  }

  -- }}}

  -- }}}
end)

-- vim:foldmethod=marker
