vim.api.nvim_command('packadd packer.nvim')
local packer = require('packer')

packer.init {
  disable_commands = true,
  log = { level = 'info' },
  profile = { enable = true, threshold = 1 },
}

local use = packer.use
-- Packer itself
use { 'wbthomason/packer.nvim', opt = true }

-- Miscellaneous {{{
use {
  'dstein64/vim-startuptime',
  cmd = 'StartupTime',
}

use {
  'ms-jpq/chadtree',
  branch = 'chad',
  run = 'python3 -m chadtree deps',
  opt = true,
}

-- Set 'path', 'includeexpr', etc. to reasonable values
use 'tpope/vim-apathy'
--}}}

-- Improvements to QuickFix and Location List{{{
use {
  'https://gitlab.com/yorickpeterse/nvim-pqf.git',
  as = "pqf",
  opt = true,
  config = function() require('pqf').setup() end,
}

use {
  'romainl/vim-qf',
  opt = true,
  setup = function ()
    vim.g.qf_mapping_ack_style = 1
    vim.g.qf_nowrap = 0
  end
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

-- Cool marks
use {
  'chentau/marks.nvim',
  config = function ()
    require('marks').setup {
      default_mappings = true,
      signs = true,
      mappings = {},
    }
  end
}

-- More and better text-objects
use { 'wellle/targets.vim' }

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
use { 'konfekt/fastfold', opt = true }
-- }}}

-- Session management {{{
-- use { 'zhimsel/vim-stay', opt = true, after = { 'fastfold', 'auto-session' } }
use { 'farmergreg/vim-lastplace' }
use {
  'rmagatti/auto-session', opt = true,
  config = function ()
    vim.opt.shada:remove('%')
    require('auto-session').setup {
      log_level = 'info',
      auto_session_suppress_dirs = { '~/', '~/Code', '~/Documents' },
    }
  end
}
--}}}

-- Editing-oriented normal mode commands {{{
use 'tpope/vim-surround'

use {
  'numToStr/Comment.nvim',
  opt = true,
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

use { 'tversteeg/registers.nvim', opt = true, }

-- Nice interface for vim's tree-shaped undo
use {  'mbbill/undotree', cmd = "UndotreeToggle" }

-- }}}

-- Moving around {{{
-- use 'rhysd/clever-f.vim'
-- use 'justinmk/vim-sneak'
use 'ggandor/lightspeed.nvim'
-- }}}

-- GIT integration {{{

use {
  'tpope/vim-fugitive',
  opt = true,
}

use {
  'tpope/vim-rhubarb',
  opt = true
}

-- Show diff when writing a commit message
use 'rhysd/committia.vim'

-- Show signs indicating which lines have been changed
use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  opt = true,
  config = function()
    require('gitsigns').setup{}
  end
}

use {
  'rhysd/git-messenger.vim',
  keys = "<Plug>(git-messenger)",
  setup = function ()
    vim.g.git_messenger_no_default_mappings = true
  end,
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
  wants = { 'harpoon' },
  requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  },
  config = function ()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local themes = require('telescope.themes')
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<D-CR>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<S-D-CR>"] = actions.smart_send_to_loclist + actions.open_loclist,
            ["<C-Space>"] = actions.complete_tag,
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        }
      },
      extensions = {
        ["ui-select"] = themes.get_cursor(),
        lsp_handlers = {
          location = { telescope = themes.get_ivy({ layout_config = { height = 12 } }) },
        },
      },
    })
    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    telescope.load_extension('lsp_handlers')
    telescope.load_extension('zoxide')
    telescope.load_extension('repo')
    telescope.load_extension('harpoon')
  end
}

use {
  'gbrlsnchs/telescope-lsp-handlers.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'jvgrootveld/telescope-zoxide',
  'cljoly/telescope-repo.nvim',
}

use {
  'nvim-telescope/telescope-frecency.nvim',
  as = 'telescope-frecency',
  after = { 'telescope.nvim' },
  requires = {
    'telescope.nvim',
    {
      'tami5/sqlite.lua',
      module = "sqlite",
      setup = function () vim.g.sqlite_clib_path = '/usr/lib/libsqlite3.dylib' end
    }
  },
  config = function () require('telescope').load_extension("frecency") end,
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
  'ThePrimeagen/harpoon',
  module = 'harpoon',
  config = function () require('harpoon').setup {} end,
}

use {
  'akinsho/bufferline.nvim',
  as = 'bufferline',
  opt = true,
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      buffer_close_icon = '✖︎ ',
      diagnostics = "coc",
      show_buffer_icons = false,
    }
  end,
}

use {
  'acerempel/trouble.nvim',
  disable = true,
  branch = 'something',
  cmd = "Trouble*",
  config = function ()
    require("trouble").setup {
      fold_closed = "▶",
      fold_open = "▼",
      padding = false,
      signs = {
        error = "⨷ ",
        warning = "⚠ ",
        hint = "¶ ",
        information = "ℹ ",
        other = " ",
      },
      auto_jump = { "lsp_definitions", "lsp_references", "lsp_implementations" },
      action_keys = {
        open_split = "s",
        open_vsplit = "v",
        open_tab = "t",
      },
      indent_lines = false,
    }
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
  '~/Code/feline.nvim', as = 'feline',
  opt = true,
  config = function () require('statusline') end,
}

use {
  'SmiteshP/nvim-gps',
  module = 'nvim-gps',
  config = function ()
    local icon = require('nvim-nonicons').get
    require('nvim-gps').setup {
      icons = {
        ['tag-name'] = '∆ ',
        ['class-name'] = icon('class'),
        ['function-name'] = 'ƒ ',
        ['method-name'] = '∂ ',
      },
      separator = ' → '
    }
  end,
}

use {
  'yamatsum/nvim-nonicons',
  opt = true,
  wants = { 'nvim-web-devicons' },
  requires = {
    'kyazdani42/nvim-web-devicons',
    config = function() require('nvim-web-devicons').setup() end,
  }
}

-- Colour schemes
use {
  'mcchrish/zenbones.nvim',
  requires = { 'rktjmp/lush.nvim' },
  wants = "lush.nvim",
  opt = true,
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

use {
  '~/Code/intero-neovim',
  setup = function ()
    vim.g.intero_backend = {
      command = 'cabal repl',
      options = '',
      cwd = vim.fn.getcwd(),
    }
  end
}

-- Tree-sitter language grammars
use {
  'nvim-treesitter/nvim-treesitter',
  run = function () vim.cmd 'TSUpdate' end,
  config = function () require('treesitter') end
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
    require('nvim-treesitter.install').compilers = { "gcc" }
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
  opt = true,
  config = function() require('lsp') end,
}

use {
  'neoclide/coc.nvim',
  as = 'coc',
  branch = 'master',
  run = 'yarn install --frozen-lockfile',
  opt = true,
}

use {
  'junegunn/fzf',
  run = ":call fzf#install()",
  opt = true,
}

use {
  'yuki-yano/fzf-preview.vim',
  as = 'fzf-preview',
  branch = 'release/remote',
  opt = true,
}

use { 'b0o/SchemaStore.nvim' }

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

-- }}}

return packer

-- vim:foldmethod=marker
