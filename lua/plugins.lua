local packer = require('packer')

_G.term = function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

_G.is_not_vscode = function() return vim.g.vscode == nil end

packer.init {
  disable_commands = true,
  log = { level = 'info' },
  profile = { enable = true, threshold = 1 },
}

local use = packer.use
  -- Packer itself
  use {  'wbthomason/packer.nvim' }

  -- ENHANCEMENTS to the basic Vim experience {{{

  -- Improvements to QuickFix and Location List
  use { 'romainl/vim-qf', disable = true }
  use { 'kevinhwang91/nvim-bqf', disable = true }
  use {
    'https://gitlab.com/yorickpeterse/nvim-pqf.git',
    config = function() require('pqf').setup() end,
  }
  use {
    'stevearc/qf_helper.nvim',
    config = function() require('qf_helper').setup() end,
  }
  use { 'Olical/vim-enmasse', cmd = "EnMasse" }

  -- Cache lua require() calls
  use 'lewis6991/impatient.nvim'

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  }

  use {
    'kevinhwang91/nvim-hlslens',
    module = 'hlslens',
  }

  use {
    'numToStr/Comment.nvim',
    cond = is_not_vscode,
    config = function()
      require('Comment').setup {
        mappings = { basic = true, extended = true },
        toggler = { line = 'gcc', block = 'gCC' },
        opleader = { line = 'gc', block = 'gC' },
        pre_hook = function ()
          require('ts_context_commentstring.internal').update_commentstring()
        end,
      }
    end
  }

  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  use {
    'andymass/vim-matchup',
    event = 'CursorMoved,CursorMovedI *',
    setup = function ()
      vim.g.matchup_matchparen_offscreen = {
        method = 'popup',
        scrolloff = 1,
      }
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_fade_time = 450
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_matchpref = { html = { tagnameonly = 1 } }
      if vim.g.vscode == 1 then
        vim.g.matchup_matchparen_enabled = 0
      end
    end,
  }

  -- Fix performance issues with the CursorHold autocmd
  use {
    'antoinemadec/FixCursorHold.nvim',
    setup = function ()
      vim.g.cursorhold_updatetime = 700
    end
  }

  -- Faster folds, I guess
  use { 'konfekt/fastfold', cond = is_not_vscode }
  use { 'zhimsel/vim-stay', after = { 'fastfold', 'auto-session' } }
  use {
    'rmagatti/auto-session', cond = is_not_vscode,
    config = function ()
      require('auto-session').setup {
        auto_session_suppress_dirs = { vim.fn.expand('~') }
      }
    end
  }

  -- }}}

  -- Editing-oriented normal mode commands {{{
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  -- Misc normal mode commands
  use { 'tpope/vim-unimpaired', opt = true }
  -- }}}

  -- Show what is otherwise hidden {{{
  -- Show available keybindings as you type
  use {
    'folke/which-key.nvim',
    cond = is_not_vscode,
    config = function ()
      require('which-key').setup {
        layout = {
          height = { min = 4, max = 20 }
        },
        plugins = {
          registers = false,
        },
        operators = {
          gc = "Comment: toggle (line)",
          gC = "Comment: toggle (block)",
          Z = "Delete without register",
        },
      }
      require('mappings')
    end
  }

  use 'tversteeg/registers.nvim'

  -- Nice interface for vim's tree-shaped undo
  use {  'mbbill/undotree', cmd = "UndotreeToggle" }

  -- }}}

  -- Moving around {{{
  use 'rhysd/clever-f.vim'
  use 'justinmk/vim-sneak'
  -- }}}

  -- GIT integration {{{

  use {
    'tpope/vim-fugitive',
  }

  -- Show diff when writing a commit message
  use 'rhysd/committia.vim'

  -- Show signs indicating which lines have been changed
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    cond = is_not_vscode,
    config = function()
      require('gitsigns').setup{}
    end
  }

  -- }}}

  -- EXTRA FEATURES {{{

  use {
    'nvim-telescope/telescope.nvim',
    module = 'telescope',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    config = function ()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
            },
          }
        }
      })
      telescope.load_extension('fzy_native')
    end
  }

  use {
    'ThePrimeagen/harpoon',
    module = 'harpoon',
    config = function () require('harpoon').setup {} end,
  }

  use {
    'folke/trouble.nvim',
    cmd = "Trouble*",
    config = function ()
      require("trouble").setup {}
    end
  }

  use {
    'sindrets/diffview.nvim',
    cmd = 'DiffviewOpen',
    config = function ()
      require('diffview').setup {}
    end
  }

  -- .editorconfig support
  use { 'editorconfig/editorconfig-vim', opt = true }

  use 'chrisbra/unicode.vim'

  -- }}}

  -- AESTHETICS {{{

  -- Pretty status line
  use {
    'famiu/feline.nvim',
    requires = { 'yamatsum/nvim-nonicons' },
    after = { 'nvim-nonicons', 'zenbones.nvim', 'nvim-gps' },
    config = function ()
      local palette = require('zenbones.palette')
      require('feline').setup {
        preset = 'default',
        colors = {
          bg = palette.bg_dim.hex,
          fg = palette.fg.hex,
          white = palette.fg1.hex,
          black = palette.bg1.hex,
          oceanblue = palette.wood.hex,
          skyblue = palette.water.hex,
          red = palette.rose.hex,
          yellow = palette.blossom.hex,
          cyan = palette.sky.hex,
          green = palette.leaf1.hex,
          orange = palette.blossom1.hex,
          violet = palette.rose1.hex,
        }
      }
    end,
  }

  use {
    'SmiteshP/nvim-gps',
    after = { 'nvim-nonicons' },
    config = function () require('nvim-gps').setup() end,
  }

  use {
    'nathom/filetype.nvim',
  }

  use {
    'yamatsum/nvim-nonicons',
    cond = is_not_vscode,
    after = { 'nvim-web-devicons' },
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'alvarosevilla95/luatab.nvim',
    after = { 'nvim-nonicons' },
    requires = { 'yamatsum/nvim-nonicons' },
    config = function ()
      vim.o.tabline = '%!v:lua.require\'luatab\'.tabline()'
    end
  }

  -- Colour schemes
  use { 'lifepillar/vim-gruvbox8', opt = true }
  use { 'bluz71/vim-nightfly-guicolors', opt = true }
  use { 'ishan9299/nvim-solarized-lua', opt = true }
  use { 'folke/tokyonight.nvim', opt = true }
  use {
    'mcchrish/zenbones.nvim',
    requires = { 'rktjmp/lush.nvim' },
    setup = function ()
      vim.opt.background = 'light'
      vim.g.zenbones_lightness = 'bright'
      vim.g.zenbones_darken_noncurrent_window = true
    end,
    config = function ()
      vim.cmd [[colorscheme zenbones]]
    end,
  }

  -- }}}

  -- LANGUAGE support {{{

  -- Syntax knowledge, incl. tree-sitter {{{

  use {
    'vimwiki/vimwiki',
    opt = true
  }

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
    cond = is_not_vscode,
    run = function () vim.cmd 'TSUpdate' end,
    config = function ()
      require('treesitter')
    end
  }
  use {
    'nvim-treesitter/playground',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }
  use {
    'RRethy/nvim-treesitter-textsubjects',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  -- }}}

  -- Semantic knowledge, incl. LSP {{{

  use {
     'nvim-lua/lsp-status.nvim',
     module = 'lsp-status',
  }
  use {
     'neovim/nvim-lspconfig',
     config = function() require('lsp') end,
  }
  use {
     'ray-x/lsp_signature.nvim',
     module = 'lsp_signature',
  }
  use {
    'simrat39/symbols-outline.nvim',
    opt = true,
    setup = function ()
      vim.g.loaded_symbols_outline = 1
    end,
    config = function ()
      require("symbols-outline").setup()
      vim.cmd [[
        augroup outline
        au!
        au FileType outline au BufLeave <buffer=abuf> lua require'symbols-outline.preview'.close()
        augroup END
      ]]
    end,
  }

  -- }}}

  -- Keystroke-saving, incl. completion {{{

  use {
    '~/Code/auto_pairs',
    event = "InsertEnter *",
  }

  use {
    'L3MON4D3/LuaSnip',
    event = "InsertEnter *",
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
      require('snippets')
    end
  }

  -- Autocomplete

  use {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter *",
    requires = {
      { "hrsh7th/cmp-buffer", opt = true, after = { 'nvim-cmp' } },
      { "saadparwaiz1/cmp_luasnip", opt = true, after = { 'nvim-cmp', 'LuaSnip' } },
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp", },
      { "hrsh7th/cmp-nvim-lua", opt = true, after = { 'nvim-cmp' } },
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
          completeopt = 'menu,menuone,noselect',
        },
        mapping = {
          -- Pears handles this now
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.close(),
          ['<Esc>'] = cmp.mapping.abort(),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<Tab>'] = function(fallback)
              if cmp.visible() then
                -- vim.api.nvim_feedkeys(term('<C-n>'), 'n', true)
                cmp.select_next_item({ cmp.SelectBehavior.Insert })
              elseif check_back_space() then
                fallback()
                -- vim.api.nvim_feedkeys(term('<Tab>'), 'n', true)
              else
                cmp.complete()
              end
            end,
          ['<S-Tab>'] = function(fallback)
              if cmp.visible() then
                -- vim.api.nvim_feedkeys(term('<C-p>'), 'n', true)
                cmp.select_next_item({ cmp.SelectBehavior.Insert })
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
    disable = true,
  }

  -- }}}

  -- }}}
  
return packer

-- vim:foldmethod=marker
