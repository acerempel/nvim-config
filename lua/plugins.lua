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
use {
  'rktjmp/highlight-current-n.nvim',
  config = function ()
    vim.cmd [[
      nmap n <Plug>(highlight-current-n-n)
      nmap N <Plug>(highlight-current-n-N)

      " Some QOL autocommands
      augroup ClearSearchHL
        autocmd!
        " You may only want to see hlsearch /while/ searching, you can automatically
        " toggle hlsearch with the following autocommands
        autocmd CmdlineEnter /,\? set hlsearch
        autocmd CmdlineLeave /,\? set nohlsearch
        " this will apply similar n|N highlighting to the first search result
        " careful with escaping ? in lua, you may need \\?
        autocmd CmdlineLeave /,\? lua require('highlight_current_n')['/,?']()
      augroup END
    ]]
  end
}

use {
  'haya14busa/vim-asterisk', as = 'asterisk',
  setup = function () vim.g['asterisk#keeppos'] = 1 end,
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

-- Cache lua require() calls
use 'lewis6991/impatient.nvim'

-- Faster folds, I guess
use { 'konfekt/fastfold', opt = true }
-- }}}

-- Session management {{{
use { 'farmergreg/vim-lastplace' }
use {
  "olimorris/persisted.nvim", as = 'persisted',
  config = function()
    vim.opt.shada:remove('%')
    require("persisted").setup {
      use_git_branch = true,
      allowed_dirs = {'~/Code', '~/Blogs', '~/.config', '~/WordPress'},
    }
    require("telescope").load_extension("persisted") -- To load the telescope extension
  end,
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
            c = { '<Cmd>lua select_git_action()<CR>', "Select git action" },
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
          bottom_pane = {
            height = 0.325,
            prompt_position = 'bottom',
          },
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
            ["<C-tab>"] = actions.move_selection_worse,
            ["<S-C-tab>"] = actions.move_selection_better,
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
          find_command = { 'fd', '-tf', '-LHu', '--strip-cwd-prefix', '-E.git', '-Enode_modules', '-Etarget', '-E.stack-work', '-Edist-newstyle', '-Evendor'  },
        },
        diagnostics = themes.get_ivy {
          no_unlisted = true,
          results_title = false,
          initial_mode = 'normal',
        }
      },
      extensions = {
        ["ui-select"] = themes.get_cursor(),
        lsp_handlers = {
          location = {
            telescope = themes.get_ivy({
              initial_mode = 'normal',
              results_title = false,
            })
          },
        },
      },
    })
    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    telescope.load_extension('lsp_handlers')
    telescope.load_extension('zoxide')
    telescope.load_extension('repo')
    telescope.load_extension('frecency')
    telescope.load_extension('file_browser')
  end
}

use {
  'gbrlsnchs/telescope-lsp-handlers.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'jvgrootveld/telescope-zoxide',
  'cljoly/telescope-repo.nvim',
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
--}}}

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
  'noib3/nvim-bufferline', as = 'cokeline',
  opt = true,
  config = function()
    local get_hex = require('cokeline.utils').get_hex
    local mappings = require('cokeline.mappings')
    local blurred_fg = get_hex('Comment', 'fg')
    local blurred_bg = get_hex('ColorColumn', 'bg')
    local focused_fg = get_hex('Normal', 'fg')
    local focused_bg = get_hex('Normal', 'bg')
    require('cokeline').setup({
      default_hl = {
        fg = function (buffer)
          return buffer.is_focused and focused_fg or blurred_fg
        end,
        bg = function (buffer)
          return buffer.is_focused and focused_bg or blurred_bg
        end,
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

-- Notifications {{{
use {
  'rcarriga/nvim-notify', as = 'notify',
  config = function ()
    require('notify').setup {
      stages = 'fade',
      timeout = 3000,
      max_width = 50,
      max_height = 25,
      render = 'minimal',
    }
    vim.cmd [[
      highlight! link NotifyERRORTitle  Directory
      highlight! link NotifyWARNTitle Directory
      highlight! link NotifyINFOTitle Directory
      highlight! link NotifyDEBUGTitle  Directory
      highlight! link NotifyTRACETitle  Directory
    ]]
    vim.notify = require('notify')
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

-- Tree-sitter {{{
use {
  'nvim-treesitter/nvim-treesitter',
  run = function () vim.cmd 'TSUpdate' end,
  config = function () require('treesitter') end
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
  end,
}
--}}}
--
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
  end
}
-- }}}
-- }}}

-- Semantic knowledge, incl. LSP {{{

use { 'neovim/nvim-lspconfig', as = 'lspconfig', }
use { 'williamboman/nvim-lsp-installer', as = 'lsp-installer', }
use { 'ray-x/lsp_signature.nvim', as = 'lsp_signature', }
use 'b0o/schemastore.nvim'
use { 'simrat39/rust-tools.nvim', as = 'rust-tools', }
use { 'j-hui/fidget.nvim', as = 'fidget', }
use { 'kosayoda/nvim-lightbulb', as = 'lightbulb', }

use {
  'RRethy/vim-illuminate', as = 'illuminate',
  config = function ()
    vim.api.nvim_create_autocmd({'VimEnter'}, {pattern = "*", callback = function ()
      vim.api.nvim_command('IlluminationDisable')
      vim.api.nvim_command('autocmd! illuminated_autocmd')
    end })
  end
}

-- }}}

-- Keystroke-saving, incl. completion {{{
-- Autopairs {{{
use {
  'windwp/nvim-autopairs',
  opt = true,
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
--}}}

-- Snippets {{{
use {
  'L3MON4D3/LuaSnip',
  module = 'luasnip',
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

-- Autocomplete {{{
use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

use {
  'hrsh7th/nvim-cmp',
  config = function ()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      preselect = cmp.PreselectMode.Item,
      completion = {
        autocomplete = false,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Esc>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      },
    }
end
}
-- }}}
-- }}}

return packer

-- vim:foldmethod=marker
