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
use { 'dstein64/vim-startuptime', cmd = 'StartupTime', }

-- Set 'path', 'includeexpr', etc. to reasonable values
use 'tpope/vim-apathy'
--}}}

-- Improvements to QuickFix and Location List{{{
use {
  'https://gitlab.com/yorickpeterse/nvim-pqf.git', as = "pqf",
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

use { 'gabrielpoca/replacer.nvim', module = 'replacer', }
--}}}

-- Existing commands improved {{{
use 'rktjmp/highlight-current-n.nvim'

-- Cool marks
use {
  'chentau/marks.nvim',
  disable = true,
  config = function ()
    require('marks').setup {
      default_mappings = true,
      signs = true,
      mappings = {},
    }
  end
}

-- More and better text-objects
use 'wellle/targets.vim'
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

use 'nathom/filetype.nvim'

-- Cache lua require() calls
use 'lewis6991/impatient.nvim'

-- Faster folds, I guess
use { 'konfekt/fastfold', opt = true }
-- }}}

-- Session management {{{
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
use 'haya14busa/vim-metarepeat'
-- }}}

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
      on_substitute = function(_)
        vim.fn["yoink#startUndoRepeatSwap"]()
      end,
    })
    vim.cmd [[
      nmap X <cmd>lua require('substitute.exchange').operator()<cr>
      nmap XX <cmd>lua require('substitute.exchange').line()<cr>
      xmap X <cmd>lua require('substitute.exchange').visual()<cr>
      nmap Xc <cmd>lua require('substitute.exchange').cancel()<cr>
      xmap p <cmd>lua require('substitute').visual()<cr>
      xmap P <cmd>lua require('substitute').visual()<cr>
    ]]
  end
}
use {
  'svermeulen/vim-yoink',
  setup = function ()
    vim.g.yoinkMaxItems = 20
    vim.g.yoinkSyncNumberedRegisters = 1
    vim.g.yoinkIncludeDeleteOperations = 1
    vim.g.yoinkSavePersistently = 1
    vim.g.yoinkAutoFormatPaste = 1
    vim.g.yoinkMoveCursorToEndOfPaste = 1
    vim.g.yoinkIncludeNamedRegisters = 0

    vim.cmd [[
      nmap p <plug>(YoinkPaste_p)
      nmap P <plug>(YoinkPaste_P)

      " Also replace the default gp with yoink paste so we can toggle paste in this case too
      nmap gp <plug>(YoinkPaste_gp)
      nmap gP <plug>(YoinkPaste_gP)

      nmap ( <plug>(YoinkPostPasteSwapBack)
      nmap ) <plug>(YoinkPostPasteSwapForward)
    ]]
  end
}--}}}

-- Show what is otherwise hidden {{{
-- Show available keybindings as you type
use {
  'folke/which-key.nvim', as = "which-key",
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
use 'ggandor/lightspeed.nvim'

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

-- Show diff when writing a commit message
use 'rhysd/committia.vim'

-- Gitsigns{{{
use {
  'lewis6991/gitsigns.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  opt = true,
  config = function()
    local function gs(f)
      return ("<Cmd>lua require('gitsigns').%s<CR>"):format(f)
    end
    function _G.select_git_action()
      local actions = require('gitsigns').get_actions()
      local items = vim.tbl_keys(actions)
      local perform = function (item)
        if item ~= nil then actions[item]() end
      end
      local format = function (item) return item end
      local prompt = "Git action:"
      vim.ui.select(items, {
        prompt = prompt,
        format = format,
      }, perform)
    end
    require('gitsigns').setup {
      on_attach = function (buf)
        local whichkey = require('which-key')
        whichkey.register(
          {
            p = { gs('preview_hunk()'), "Preview hunk diff" },
            r = { gs('reset_hunk()'), "Restore hunk from the index" },
            R = { gs('reset_buffer()'), "Restore all hunks from the index" },
            s = { gs('stage_hunk()'), "Stage hunk" },
            S = { gs('stage_buffer()'), "Stage buffer" },
            u = { gs('undo_stage_hunk()'), "Undo stage hunk" },
            U = { gs('reset_buffer_index()'), "Restore buffer from the index" },
            b = { gs('blame_line()'), "Show last commit affecting this line" },
            d = { gs('diffthis()'), "Diff file against index" },
            c = { 'lua select_git_action()', "Select git action" },
          },
          { prefix = '<Leader>c', buffer = buf }
        )
        whichkey.register(
          {
            ['[c'] = { gs('prev_hunk()'), 'Go to previous change' },
            [']c'] = { gs('next_hunk()'), 'Go to next hunk' }
          },
          { buffer = buf }
        )
      end
    }
  end
}
--}}}
use {
  'sindrets/diffview.nvim',
  cmd = 'DiffviewOpen',
  config = function () require('diffview').setup {} end,
}

use {
  'rhysd/git-messenger.vim',
  keys = "<Plug>(git-messenger)",
  setup = function ()
    vim.g.git_messenger_no_default_mappings = true
  end,
}

-- }}}

use "chrisbra/NrrwRgn"

-- Telescope {{{
use {
  'nvim-telescope/telescope.nvim', as = 'telescope',
  opt = true,
  wants = {
    'session-lens',
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
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local layout_actions = require('telescope.actions.layout')
    local themes = require('telescope.themes')
    telescope.setup({
      defaults = {
        disable_devicons = true,
        color_devicons = false,
        layout_strategy = 'vertical',
        layout_config = {
          horizontal = { height = 0.5 },
          cursor = { height = 0.5 },
          vertical = {
            height = 0.625,
            preview_cutoff = 10,
            width = 0.5,
          },
        },
        preview = { hide_on_startup = true, },
        mappings = {
          i = {
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<D-CR>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<S-D-CR>"] = actions.smart_send_to_loclist + actions.open_loclist,
            ["<C-Space>"] = actions.complete_tag,
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<D-k>"] = layout_actions.toggle_preview,
          },
        },
      },
      pickers = {
        buffers = {
          show_all_buffers = true, ignore_current_buffer = true,
          sort_mru = true, bufnr_width = 3,
          disable_devicons = true,
        },
        find_files = {
          disable_devicons = true,
          preview = { hide_on_startup = true, },
          find_command = { 'fd', '-tf', '-LHu', '--strip-cwd-prefix', '-E.git', '-Enode_modules', '-Etarget', '-E.stack-work', '-Edist-newstyle'  },
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
    telescope.load_extension('frecency')
    telescope.load_extension('coc')
    telescope.load_extension('file_browser')
  end
}

use {
  'gbrlsnchs/telescope-lsp-handlers.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'jvgrootveld/telescope-zoxide',
  'cljoly/telescope-repo.nvim',
  'fannheyward/telescope-coc.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
}

use {
  'nvim-telescope/telescope-frecency.nvim', as = 'telescope-frecency',
  requires = {
    {
      'tami5/sqlite.lua',
      module = "sqlite",
      setup = function () vim.g.sqlite_clib_path = '/usr/lib/libsqlite3.dylib' end
    }
  },
}

use {
  'rmagatti/session-lens', opt = true,
  wants = { 'auto-session' },
  config = function ()
    require('session-lens').setup {
      path_display = 'shorten',
    }
  end
}
--}}}

-- .editorconfig support
use { 'editorconfig/editorconfig-vim', opt = true }

use 'tpope/vim-eunuch'

use {
  "tpope/vim-scriptease",
  cmd = {
    "Messages", --view messages in quickfix list
    "Verbose", -- view verbose output in preview window.
    "Time", -- measure how long it takes to run some stuff.
  },
}

-- AESTHETICS {{{

-- status line {{{
use {
  'nvim-lualine/lualine.nvim', as = 'lualine',
  opt = true,
  config = function ()
    local function diff_source()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed
        }
      end
    end
    local gps = require('nvim-gps')
    local function is_special()
      local buftype = vim.bo.buftype
      return buftype == 'help' or buftype == 'quickfix' or buftype == 'terminal'
    end
    local function special_filename()
      local buftype = vim.bo.buftype
      if buftype == 'help' then
        return vim.fn.expand('%:t')
      elseif buftype == 'quickfix' then
        local wintype = vim.fn.win_gettype()
        if wintype == 'quickfix' then
          return vim.fn.getqflist({title = 1}).title
        elseif wintype == 'loclist' then
          return  vim.fn.getloclist({title = 1}).title
        end
      elseif buftype == 'terminal' then
        return vim.b.term_title
      else
        return '???'
      end
    end
    local function min_width(w)
      return function ()
        local name = vim.api.nvim_buf_get_name(0)
        local winw = vim.api.nvim_win_get_width(0)
        return winw - #name >= w
      end
    end
    local section_a = {
      {
        'filename', path = 1,
        symbols = { modified = ' ⊕', readonly = ' ⊖', unnamed = '‹no name›' },
        cond = function() return not is_special() end,
      },
      {
        special_filename,
        cond = is_special,
      },
    }
    local section_b = {
      {'diff', source = diff_source}, {'b:gitsigns_head', icon = '', cond = min_width(80) }
    }
    require('lualine').setup {
      options = {
        theme = 'zenbones_light_bright',
      },
      sections = {
        lualine_a = section_a,
        lualine_b = section_b,
        lualine_c = { {gps.get_location, cond = function () return gps.is_available() and min_width(65)() end} },
        lualine_x = { {function () return vim.fn['coc#status']() end, cond = min_width(50)} },
        lualine_y = {'progress'},
        lualine_z = {'mode'},
      },
      inactive_sections = {
        lualine_a = section_a,
        lualine_b = section_b,
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      }
    }
  end
}

use {
  'SmiteshP/nvim-gps',
  module = 'nvim-gps',
  config = function ()
    local icon = require('nvim-nonicons').get
    require('nvim-gps').setup {
      icons = {
        ['tag-name'] = icon('struct'),
        ['class-name'] = icon('class'),
        ['function-name'] = 'ƒ ',
        ['method-name'] = '∂ ',
      },
      separator = ' → '
    }
  end,
}

-- }}}

-- Buffer line {{{
use {
  'noib3/nvim-cokeline', as = 'cokeline',
  opt = true,
  config = function()
    local get_hex = require('cokeline.utils').get_hex
    local mappings = require('cokeline.mappings')
    require('cokeline').setup({
      default_hl = {
        unfocused = {
          fg = get_hex('Comment', 'fg'),
          bg = get_hex('ColorColumn', 'bg'),
        },
        focused = {
          fg = get_hex('Normal', 'fg'),
          bg = get_hex('Normal', 'bg'),
        },
      },

      components = {
        { text = function (buffer) return buffer.index ~= 1 and '▎' or '' end, },
        {
          text = function(buffer)
            local id
            if mappings.is_picking_focus() or mappings.is_picking_close() then
              id = buffer.pick_letter
            else
              id = buffer.index
            end
            return ' ' .. id .. ' '
          end,
        },
        {
          text = function(buffer) return buffer.unique_prefix end,
          hl = {
            fg = get_hex('Comment', 'fg'),
            style = 'italic',
          },
        },
        {
          text = function(buffer) return buffer.filename .. ' ' end,
          hl = {
            style = function(buffer) return buffer.is_focused and 'bold' or nil end,
          },
        },
        {
          text = function (buffer) return buffer.is_modified and '⚫︎ ' or '🟂  ' end,
          delete_buffer_on_left_click = true,
        },
      },
    })
  end,
}
-- }}}

-- Icons {{{
use {
  'yamatsum/nvim-nonicons',
  opt = true,
  wants = { 'nvim-web-devicons' },
  requires = {
    'kyazdani42/nvim-web-devicons',
    config = function() require('nvim-web-devicons').setup() end,
  }
}
-- }}}
-- Colour schemes {{{
use { 'rktjmp/lush.nvim', as = 'lush', opt = true }
use {
  'mcchrish/zenbones.nvim', as = 'zenbones', opt = true,
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

-- }}}

-- Syntax knowledge, incl. tree-sitter {{{

use { 'ledger/vim-ledger', as = 'ledger', }

-- Vimwiki {{{
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
--}}}

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
  disable = true,
  setup = function ()
    vim.g.intero_backend = {
      command = 'cabal repl',
      options = '',
      cwd = vim.fn.getcwd(),
    }
  end
}

-- Tree-sitter {{{
use {
  'nvim-treesitter/nvim-treesitter',
  run = function () vim.cmd 'TSUpdate' end,
  config = function () require('treesitter') end
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
-- Treesitter playground {{{
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
--}}}
use {
  'nvim-treesitter/nvim-treesitter-textobjects',
  requires = { 'nvim-treesitter/nvim-treesitter' },
}
use {
  'RRethy/nvim-treesitter-textsubjects',
  requires = { 'nvim-treesitter/nvim-treesitter' },
}
-- }}}
-- }}}

-- Semantic knowledge, incl. LSP {{{

use {
  'neoclide/coc.nvim',
  as = 'coc',
  branch = 'master',
  run = 'yarn install --frozen-lockfile',
  opt = true,
}

-- }}}

-- Keystroke-saving, incl. completion {{{

use {
  '~/Code/auto_pairs',
  cond = is_not_vscode,
  event = "InsertEnter *",
}

-- Snippets {{{
use {
  'L3MON4D3/LuaSnip',
  event = "InsertEnter *",
  disable = true,
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
--}}}
-- Autocomplete

-- }}}

return packer

-- vim:foldmethod=marker
