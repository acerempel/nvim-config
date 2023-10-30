vim.api.nvim_command('packadd packer.nvim')
local packer = require('packer')

packer.init {
  log = { level = 'info' },
}

local use = packer.use

use { 'wbthomason/packer.nvim', opt = true }

use { 'dstein64/vim-startuptime', cmd = 'StartupTime', }

-- Set 'path', 'includeexpr', etc. to reasonable values
use 'tpope/vim-apathy'

-- Improvements to QuickFix and Location List{{{
use {
  'https://gitlab.com/yorickpeterse/nvim-pqf.git', as = "pqf",
  config = function() require('pqf').setup() end,
}

use {
  'romainl/vim-qf',
  setup = function ()
    vim.g.qf_mapping_ack_style = 1
    vim.g.qf_nowrap = 0
  end
}

use 'gabrielpoca/replacer.nvim'
--}}}

use {
  'tzachar/highlight-undo.nvim', as = 'highlight-undo',
  config = function() require('highlight-undo').setup() end,
}

-- More and better text-objects
use 'wellle/targets.vim'

use 'tpope/vim-repeat'

-- Faster folds, I guess
use { 'konfekt/fastfold', opt = true }

use 'farmergreg/vim-lastplace'

use 'tpope/vim-surround'

use 'haya14busa/vim-metarepeat'

-- Comment {{{
use {
  'numToStr/Comment.nvim', as = 'Comment',
  opt = true,
  config = function()
    require('Comment').setup {
      mappings = { basic = true, extended = true },
      toggler = { line = 'gcc', block = 'gCC' },
      opleader = { line = 'gc', block = 'gC' },
      pre_hook = function ()
        require('ts_context_commentstring.internal').update_commentstring()
      end,
    }
    require('which-key').register {
      g = {
        c = "Comment: toggle (line)",
        C = "Comment: toggle (block)",
        cc = "Line",
        CC = "Line",
        ['>'] = "Comment: add",
        ['<'] = "Comment: remove",
      }
    }
  end
}
-- }}}

-- Paste and yank and delete improvements {{{
use {
  'gbprod/substitute.nvim', as = 'substitute',
  config = function ()
    require("substitute").setup({
      on_substitute = function(event)
        require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
      end,
    })
    vim.cmd [[
      nmap X <cmd>lua require('substitute').operator()<cr>
      nmap XX <cmd>lua require('substitute').line()<cr>
      xmap X <cmd>lua require('substitute').visual()<cr>
      nmap Xc <cmd>lua require('substitute').cancel()<cr>
    ]]
  end
}

use {
  'gbprod/yanky.nvim',
  config = function ()
    require('yanky').setup {
      ring = {
        history_length = 25,
      },
    }

    vim.api.nvim_set_keymap("n", "p", "<Plug>(YankyPutAfter)", {})
    vim.api.nvim_set_keymap("n", "P", "<Plug>(YankyPutBefore)", {})
    vim.api.nvim_set_keymap("x", "p", "<Plug>(YankyPutAfter)", {})
    vim.api.nvim_set_keymap("x", "P", "<Plug>(YankyPutBefore)", {})
    vim.api.nvim_set_keymap("n", "gp", "<Plug>(YankyGPutAfter)", {})
    vim.api.nvim_set_keymap("n", "gP", "<Plug>(YankyGPutBefore)", {})
    vim.api.nvim_set_keymap("x", "gp", "<Plug>(YankyGPutAfter)", {})
    vim.api.nvim_set_keymap("x", "gP", "<Plug>(YankyGPutBefore)", {})

    vim.api.nvim_set_keymap("n", "<c-n>", "<Plug>(YankyCycleForward)", {})
    vim.api.nvim_set_keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)", {})

    vim.api.nvim_set_keymap("n", "y", "<Plug>(YankyYank)", {})
    vim.api.nvim_set_keymap("x", "y", "<Plug>(YankyYank)", {})
  end
}
--}}}

-- Show available keybindings as you type {{{
use {
  'folke/which-key.nvim', as = "which-key",
  tag = 'v1.6.0',
  opt = true,
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
      window = {
        winblend = 10,
      },
    }
    require('mappings')
  end
}
-- }}}

use {
  'tversteeg/registers.nvim',
  config = function () require('registers').setup() end
}

-- Nice interface for vim's tree-shaped undo
use {  'mbbill/undotree', cmd = "UndotreeToggle" }

-- Moving around {{{
use 'ggandor/lightspeed.nvim'

use 'romainl/vim-cool'

use {
  'haya14busa/vim-asterisk', as = 'asterisk',
  config = function ()
    vim.cmd [[
      map *   <Plug>(asterisk-*)
      map #   <Plug>(asterisk-#)
      map g*  <Plug>(asterisk-g*)
      map g#  <Plug>(asterisk-g#)
      map z*  <Plug>(asterisk-z*)
      map gz* <Plug>(asterisk-gz*)
      map z#  <Plug>(asterisk-z#)
      map gz# <Plug>(asterisk-gz#)
    ]]
  end
}

-- Matchup {{{
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
  config = function ()
    require('which-key').register {
      ['%'] = "Next matching word",
      ['z%'] = "Go within Nth nearest block",
      ['g%'] = "Previous matching word",
      ['[%'] = "Previous outer opening word",
      [']%'] = "Next outer closing word",
    }
  end
}
-- }}}
-- }}}

-- GIT integration {{{

use { 'tpope/vim-fugitive', opt = true, }
use { 'idanarye/vim-merginal', cmd = 'Merginal' }

-- Show diff when writing a commit message
use 'rhysd/committia.vim'

use {
  'rhysd/conflict-marker.vim', as = 'conflict',
  setup = function ()
    vim.g.conflict_marker_enable_mappings = 0
    vim.g.conflict_marker_enable_matchit = 0
  end
  -- TODO mappings
}

use {
  'lewis6991/gitsigns.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  opt = true,
  config = function()
    require('conf.gitsigns')
  end
}

use {
  'sindrets/diffview.nvim',
  cmd = 'DiffviewOpen',
  config = function () require('diffview').setup {} end,
}

-- }}}

-- Telescope {{{
use {
  'nvim-telescope/telescope.nvim', as = 'telescope',
  opt = true,
  wants = {
    'popup.nvim',
    'plenary.nvim',
    'telescope-fzf-native.nvim',
  },
  requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  },
  config = function ()
    require('conf.telescope')
  end
}

use {
  'gbrlsnchs/telescope-lsp-handlers.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'jvgrootveld/telescope-zoxide',
  'nvim-telescope/telescope-file-browser.nvim',
}

use {
  'nvim-telescope/telescope-frecency.nvim', as = 'telescope-frecency',
}
--}}}

use {
  "tpope/vim-scriptease",
  cmd = {
    "Messages", --view messages in quickfix list
    "Verbose", -- view verbose output in preview window.
    "Time", -- measure how long it takes to run some stuff.
  },
}

-- status line {{{
use {
  'nvim-lualine/lualine.nvim', as = 'lualine',
  config = function () require('conf.lualine') end
}

use {
  'SmiteshP/nvim-gps',
  module = 'nvim-gps',
  config = function ()
    require('nvim-gps').setup {
      icons = {
        ['tag-name'] = '❮❯',
        ['class-name'] = '∏ ',
        ['function-name'] = 'λ ',
        ['method-name'] = 'ƒ ',
        ['container-name'] = '⛶ '
      },
      separator = ' → ',
      languages = {
        json = {
          icons = {
            ["object-name"] = '{}',
            ["boolean-name"] = '⊨ ',
            ["array-name"] = '[]',
          }
        }
      }
    }
  end,
}

-- }}}

use {
  'noib3/nvim-bufferline', as = 'cokeline',
  opt = true,
  config = function() require('conf.cokeline') end,
}

-- Colour schemes {{{
use { 'rktjmp/lush.nvim', as = 'lush' }

use {
  'mcchrish/zenbones.nvim', as = 'zenbones',
  config = function ()
    vim.g.zenbones = {
      lightness = 'bright',
      darken_noncurrent_window = true,
      darken_comments = 67,
    }
    vim.cmd [[
      set termguicolors
      set background=light
      colorscheme zenbones
    ]]
  end
}
-- }}}

-- Syntaxes, filetypes {{{

use { 'ledger/vim-ledger', as = 'ledger', }

use {
  'vimwiki/vimwiki',
  event = { "BufReadPost,BufNew *.wiki" },
  setup = function ()
    vim.cmd [[
      let g:vimwiki_list =
        \ [{'path': '~/Documents/Grand-Schemes',
        \   'path_html': '~/Documents/Grand-Schemes/Hypertext',
        \   'index': 'Index',
        \   'auto_toc': 1,
        \   'syntax': 'default',
        \   'ext': '.wiki',
        \   'template_path': '~/Documents/Grand-Schemes/Templates',
        \   'template_default': 'default',
        \   'template_ext': '.template.html',
        \   'diary_rel_path': 'Catalogue-of-Days',
        \   'diary_index': 'Days',
        \   'diary_header': 'The Catalogue of Days',
        \   'diary_sort': 'desc',
        \   'auto_tags': 1,
        \   'auto_diary_index': 1,
        \ }]

      let g:vimwiki_dir_link = 'Index'
      let g:vimwiki_html_header_numbering = 2
      let g:vimwiki_html_header_numbering_sym = '.'
      let g:vimwiki_autowriteall = 0
      let g:vimwiki_ext2syntax = {}
      let g:vimwiki_global_ext = 0
    ]]
  end
}

use { 'neovimhaskell/haskell-vim', ft = 'haskell' }

use {
  'gabrielelana/vim-markdown',
  ft = 'markdown',
  setup = function ()
    vim.g.markdown_enable_mappings = 0
    vim.g.markdown_enable_input_abbreviations = 0
    vim.g.markdown_enable_insert_mode_mappings = 1
  end,
}
-- }}}

-- Tree-sitter {{{
use {
  'nvim-treesitter/nvim-treesitter',
  run = function () vim.cmd 'TSUpdate' end,
  config = function () require('conf.treesitter') end
}

use {
  'joosepalviste/nvim-ts-context-commentstring',
  module = 'ts_context_commentstring',
  config = function ()
    require('nvim-treesitter.configs').setup {
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      }
    }
  end,
}

use {
  'nvim-treesitter/playground',
  cmd = 'TSPlaygroundToggle',
  requires = { 'nvim-treesitter/nvim-treesitter' },
  config = function ()
    require('nvim-treesitter.configs').setup {
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
  end,
}

use { 'nvim-treesitter/nvim-treesitter-textobjects', }
use { 'RRethy/nvim-treesitter-textsubjects', }

use {
  'm-demare/hlargs.nvim', as = 'hlargs',
  config = function ()
    require('hlargs').setup {
      performance = {
        parse_delay = 15,
        slow_parse_delay = 100,
        debounce = {
          partial_parse = 30,
          partial_insert_mode = 450,
        }
      }
    }
    vim.api.nvim_command('hi! link Hlargs Constant')
  end
}
-- }}}

-- LSP {{{

use { 'neovim/nvim-lspconfig', as = 'lspconfig', opt = true }
use { 'williamboman/nvim-lsp-installer', as = 'lsp-installer', }
use { 'ray-x/lsp_signature.nvim', as = 'lsp_signature', opt = true }
use 'b0o/schemastore.nvim'
use { 'simrat39/rust-tools.nvim', as = 'rust-tools', opt = true }
use { 'j-hui/fidget.nvim', as = 'fidget', tag = 'legacy', opt = true }
use { 'kosayoda/nvim-lightbulb', as = 'lightbulb', opt = true }

use {
  'filipdutescu/renamer.nvim', as = 'renamer',
  branch = 'master',
  opt = true,
  requires = { 'nvim-lua/plenary.nvim' },
  config = function ()
    require('renamer').setup {
      with_qf_list = false,
      mappings = {},
    }
  end
}

use {
  'rmagatti/goto-preview',
  module = 'goto-preview',
  config = function ()
    require('goto-preview').setup {
      width = 80,
      height = 20,
    }
  end
}

use { 'weilbith/nvim-code-action-menu', as = 'code-action-menu' }

-- }}}

use {
  'windwp/nvim-autopairs',
  event = "InsertEnter *",
  config = function ()
    local pairs = require('nvim-autopairs')
    pairs.setup {
      map_cr = true,
      map_c_w = true,
    }
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')
    pairs.add_rules {
      Rule('<', '>', {'rust'})
        :with_pair(cond.before_regex('[%w:]'))
    }
    pairs.remove_rule(">[%w%s]*$") -- CoC does this for us
  end
}

use {
  'L3MON4D3/LuaSnip',
  module = 'luasnip',
  config = function () require('conf.luasnip') end
}

-- Autocomplete {{{
use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

use {
  'hrsh7th/nvim-cmp',
  config = function () require('conf.cmp') end
}
-- }}}

return packer

-- vim:foldmethod=marker
