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
