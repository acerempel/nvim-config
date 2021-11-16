vim.api.nvim_command('packadd packer.nvim')
local packer = require('packer')

packer.init {
  disable_commands = true,
  log = { level = 'info' },
  profile = { enable = true, threshold = 1 },
}

local use = packer.use
-- Packer itself
use {  'wbthomason/packer.nvim', opt = true }

-- Miscellaneous {{{
use {
  'dstein64/vim-startuptime',
  cmd = 'StartupTime',
}

-- Set 'path', 'includeexpr', etc. to reasonable values
use 'tpope/vim-apathy'
--}}}

-- Improvements to QuickFix and Location List{{{
use {
  'https://gitlab.com/yorickpeterse/nvim-pqf.git',
  cond = is_not_vscode,
  config = function() require('pqf').setup() end,
}

use {
  'romainl/vim-qf',
  cond = is_not_vscode,
  event = "QuickFixCmdPost",
  ft = "qf",
  setup = function ()
    vim.g.qf_mapping_ack_style = 1
    vim.g.qf_nowrap = 0
  end
}

use {
  'stevearc/qf_helper.nvim',
  ft = 'qf',
  config = function()
    require('qf_helper').setup {
      quickfix = {
        default_bindings = false,
      },
      loclist = {
        default_bindings = false,
      },
    }
  end,
}
use { 'Olical/vim-enmasse', cmd = "EnMasse" }
use {
  'gabrielpoca/replacer.nvim',
  module = 'replacer',
}
--}}}

-- Existing commands improved {{{
use {
  'kevinhwang91/nvim-hlslens',
  module = 'hlslens',
}

-- More and better text-objects
use {
  'wellle/targets.vim'
}

use {
  'joosepalviste/nvim-ts-context-commentstring',
  module = 'ts_context_commentstring',
  requires = { 'nvim-treesitter/nvim-treesitter' },
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
  'andymass/vim-matchup',
  after = { 'which-key.nvim' },
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

-- Invisible improvements {{{
-- Fix performance issues with the CursorHold autocmd
use {
  'antoinemadec/FixCursorHold.nvim',
  setup = function ()
    vim.g.cursorhold_updatetime = 700
  end
}

use 'tpope/vim-repeat'

use {
  'nathom/filetype.nvim',
}

-- Cache lua require() calls
use {
  'lewis6991/impatient.nvim',
}

-- Faster folds, I guess
use { 'konfekt/fastfold', cond = is_not_vscode }
-- }}}

-- Session management {{{
use { 'zhimsel/vim-stay', cond = is_not_vscode, after = { 'fastfold', 'auto-session' } }
use {
  'rmagatti/auto-session', cond = is_not_vscode,
  config = function ()
    require('auto-session').setup {
      auto_session_suppress_dirs = { vim.fn.expand('~') }
    }
  end
}
--}}}

-- Editing-oriented normal mode commands {{{
use 'tpope/vim-surround'
use {
  'numToStr/Comment.nvim',
  cond = is_not_vscode,
  after = { 'which-key.nvim' },
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
      window = {
        winblend = 10,
      },
    }
    require('mappings')
  end
}

use { 'tversteeg/registers.nvim', cond = is_not_vscode, }

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
  cond = is_not_vscode,
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
  'haya14busa/vim-metarepeat',
  keys = 'g.',
}

use {
  "chrisbra/NrrwRgn",
  cmd = { "NarrowRegion", "NarrowWindow", "NR", "NW", "NRV", },
  keys = { "<Leader>nr" },
}

use {
  'nvim-telescope/telescope.nvim',
  module = 'telescope',
  cmd = 'Telescope',
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
            ["<Tab>"] = actions.toggle_selection,
          },
          n = {
            ["<Tab>"] = actions.toggle_selection,
          },
        }
      }
    })
    telescope.load_extension('fzy_native')
  end
}

use {
  'nvim-telescope/telescope-frecency.nvim',
  after = { 'telescope.nvim' },
  requires = {
    'telescope.nvim',
    { 'tami5/sqlite.lua', setup = function () vim.g.sqlite_clib_path = '/usr/lib/libsqlite3.dylib' end }
  },
  config = function () require('telescope').load_extension("frecency") end,
}

use {
  'jvgrootveld/telescope-zoxide',
  after = { 'telescope.nvim' },
  config = function () require'telescope'.load_extension('zoxide') end
}

use {
  'rmagatti/session-lens',
  after = { 'telescope.nvim', 'auto-session' },
  config = function ()
    require('session-lens').setup {
      path_display = 'shorten',
    }
  end
}

use {
  'AckslD/nvim-neoclip.lua',
  as = "neoclip",
  requires = { 'tami5/sqlite.lua' },
  config = function ()
    require('neoclip').setup {
      history = 100,
      enable_persistant_history = true,
    }
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

use {
  'tpope/vim-eunuch',
  cmd = { 'Delete', 'Unlink', 'Move', 'Rename', 'Chmod', 'Mkdir', 'Cfind', 'Clocate', 'Lfind', 'Llocate', 'Wall', 'SudoWrite', 'SudoEdit', },
}

use {
  "tpope/vim-scriptease",
  cmd = {
    "Messages", --view messages in quickfix list
    "Verbose", -- view verbose output in preview window.
    "Time", -- measure how long it takes to run some stuff.
  },
}
-- }}}

-- AESTHETICS {{{

-- Pretty status line
use {
  '~/Code/feline.nvim',
  requires = { 'yamatsum/nvim-nonicons' },
  after = { 'zenbones.nvim', 'nvim-gps' },
  config = function ()
    require('statusline')
  end,
}

use {
  'SmiteshP/nvim-gps',
  after = { 'nvim-nonicons' },
  module = 'nvim-gps',
  config = function ()
    local icon = require('nvim-nonicons').get
    require('nvim-gps').setup {
      icons = {
        ['tag-name'] = icon('field'),
        ['class-name'] = icon('class'),
        ['function-name'] = 'ƒ ',
        ['method-name'] = icon('interface'),
      },
      separator = ' → '
    }
  end,
}

use {
  'yamatsum/nvim-nonicons',
  cond = is_not_vscode,
  after = { 'nvim-web-devicons' },
  requires = {'kyazdani42/nvim-web-devicons'}
}

use {
  '~/Code/luatab.nvim',
  after = { 'nvim-nonicons' },
  config = function ()
    vim.o.tabline = '%!v:lua.require\'luatab\'.tabline()'
  end
}

-- Colour schemes
use {
  'mcchrish/zenbones.nvim',
  requires = { 'rktjmp/lush.nvim' },
  setup = function ()
    vim.opt.background = 'light'
    vim.g.zenbones_lightness = 'bright'
    vim.g.zenbones_darken_noncurrent_window = true
  end,
  config = function ()
    vim.api.nvim_command [[colorscheme zenbones]]
  end,
}

-- }}}

-- Syntax knowledge, incl. tree-sitter {{{

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

-- Syntax highlighting and suchlike
use { 'neovimhaskell/haskell-vim', cond = is_not_vscode, ft = 'haskell' }
use {
  'gabrielelana/vim-markdown',
  ft = 'markdown',
  cond = is_not_vscode,
  setup = function ()
    vim.g.markdown_enable_mappings = 0
    vim.g.markdown_enable_input_abbreviations = 0
    vim.g.markdown_enable_insert_mode_mappings = 1
  end,
}

-- Tree-sitter language grammars
use {
  'nvim-treesitter/nvim-treesitter',
  run = function () vim.cmd 'TSUpdate' end,
  config = function ()
    require('treesitter')
  end
}
use {
  'nvim-treesitter/playground',
  cmd = 'TSPlaygroundToggle',
  cond = is_not_vscode,
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
  cond = is_not_vscode,
  config = function() require('lsp') end,
}
use {
  'williamboman/nvim-lsp-installer',
}
use {
  'ray-x/lsp_signature.nvim',
  module = 'lsp_signature',
}
use {
  'simrat39/symbols-outline.nvim',
  module = 'symbols-outline',
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
  cond = is_not_vscode,
  event = "InsertEnter *",
}

use {
  'L3MON4D3/LuaSnip',
  event = "InsertEnter *",
  cond = is_not_vscode,
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
        return require('util').term('<Cmd>lua luasnip.change_choice(1)<CR>')
      else
        return require('util').term('<C-n>')
      end
    end
    _G.mapping_ctrl_p = function ()
      if luasnip.choice_active() then
        return require('util').term('<Cmd>lua luasnip.change_choice(-1)<CR>')
      else
        return require('util').term('<C-p>')
      end
    end
    vim.api.nvim_set_keymap("i", "<C-n>", "v:lua.mapping_ctrl_n()", { expr = true, noremap = true })
    vim.api.nvim_set_keymap("s", "<C-n>", "v:lua.mapping_ctrl_n()", { expr = true, noremap = true })
    vim.api.nvim_set_keymap("i", "<C-p>", "v:lua.mapping_ctrl_p()", { expr = true, noremap = true })
    vim.api.nvim_set_keymap("s", "<C-p>", "v:lua.mapping_ctrl_p()", { expr = true, noremap = true })
    require('snippets')
  end
}

-- Autocomplete

use {
  'hrsh7th/nvim-cmp',
  cond = is_not_vscode,
  event = "InsertEnter *",
  requires = {
    { "hrsh7th/cmp-buffer", opt = true, after = { 'nvim-cmp' } },
    { "saadparwaiz1/cmp_luasnip", opt = true, after = { 'nvim-cmp', 'LuaSnip' } },
    { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp", after = { 'nvim-cmp' } },
    { "hrsh7th/cmp-nvim-lua", opt = true, after = { 'nvim-cmp' } },
  },
  config = function ()
    local cmp = require('cmp')
    local util = require('util')
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
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- vim.api.nvim_feedkeys(require('util').term('<C-n>'), 'n', true)
            cmp.select_next_item({ cmp.SelectBehavior.Insert })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif util.check_back_space() then
            fallback()
            -- vim.api.nvim_feedkeys(require('util').term('<Tab>'), 'n', true)
          else
            cmp.complete()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- vim.api.nvim_feedkeys(require('util').term('<C-p>'), 'n', true)
            cmp.select_prev_item({ cmp.SelectBehavior.Insert })
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
            -- vim.api.nvim_feedkeys(require('util').term('<S-Tab>'), 'n', true)
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'buffer' },
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

return packer

-- vim:foldmethod=marker
