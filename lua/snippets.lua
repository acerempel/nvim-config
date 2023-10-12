local luasnip = require('luasnip')

local snippet = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node
local choice = luasnip.choice_node
local func = luasnip.function_node
local node = luasnip.snippet_node
local dyn = luasnip.dynamic_node

local tagpair = snippet(
  {
    trig = "<([%w_-]+)>",
    name = "HTML/XML tag pair",
    wordTrig = false,
    regTrig = true,
  },
  {
    luasnip.function_node(function (_args, snip)
      return '<' .. snip.captures[1] .. '>'
    end, {}),
    luasnip.text_node({ '', '\t' }),
    luasnip.insert_node(0),
    luasnip.text_node({ '', '' }),
    luasnip.function_node(function (_args, snip)
      return '</' .. snip.captures[1] .. '>'
    end, {}),
  }
)

local input = snippet(
  {
    trig = "<input",
    wordTrig = false,
    name = "HTML input element",
  },
  {
    luasnip.text_node('<input name="'),
    luasnip.insert_node(1),
    luasnip.text_node('" type="'),
    luasnip.choice_node(2, {
      luasnip.text_node('text'),
      luasnip.text_node('email'),
      luasnip.text_node('password'),
      luasnip.text_node('range'),
      luasnip.text_node('radio'),
      luasnip.text_node('checkbox'),
    }),
    luasnip.text_node('">')
  }
)

local anchor = snippet(
  {
    trig = "<a",
    wordTrig = false,
    name = "HTML anchor element"
  },
  {
    text('<a href="'), insert(2),
    text('">'), insert(1),
    text('</a>')
  }
)

local stylesheet = snippet(
  {
    trig = "stylesheet",
    name = '<link rel="stylesheet">',
  },
  {
    text('<link rel="stylesheet" href="'),
    insert(1, '/style.css'),
    text('"'),
    choice(2, { text(''), luasnip.snippet_node(nil, { text(' media="'), insert(nil, 'screen') }) }),
    text('>')
  }
)

local description = snippet(
  {
    trig = "description",
    name = '<meta name="description" …>',
  },
  { text('<meta name="description" content="'), insert(1), text('">') }
)

local doctype = snippet(
  { trig = "doctype", name = "<!DOCTYPE html>" },
  { text({ '<!DOCTYPE html>', '' }) }
)

local html = snippet(
  { trig = "html", name = "HTML document skeleton" },
  {
    text({ '<!DOCTYPE html>', '<html lang="' }), insert(1, 'en'),
    text({ '">', '\t<head>', '\t\t<meta charset="utf-8">',
      '\t\t<meta name="viewport" content="width=device-width, initial-scale=1">',
      '\t\t<title>' }), insert(2, 'Good evening!'), text({ '</title>', '\t</head>',
      '\t<body>', '\t\t' }), insert(0), text({ '', '\t</body>', '</html>' })
  }
)

local php = snippet(
  { trig = '<?', name = "<?php … ?>", wordTrig = false },
  {
    luasnip.text_node('<?php '),
    luasnip.insert_node(1),
    luasnip.text_node(' ?>'),
  }
)

local php_if = snippet(
  'if',
  {
    text('if ('), insert(1), text({ ') {', '\t' }),
    insert(0), text({ '', '}' })
  }
)

local php_phpif = snippet(
  'phpif',
  {
    text('<?php if ( '), insert(1), text(' ) : ?>'),
    text({ '', '\t' }), insert(0),
    text({ '', '<?php endif; ?>' }),
  }
)

local lua_pairs = snippet(
  'forpairs',
  {
    text('for '), insert(1, 'key'), text(', '), insert(2, 'value'),
    text(' in pairs('), insert(3), text({ ') do', '', '\t' }),
    insert(0), text({ '', 'end' })
  }
)

local lua_ipairs = snippet(
  'foripairs',
  {
    text('for '), insert(1, 'index'), text(', '), insert(2, 'value'),
    text(' in ipairs('), insert(3), text({ ') do', '\t' }),
    insert(0), text({ '', 'end' })
  }
)

local lua_pcall = snippet(
  { trig = 'pcall' },
  {
    text('local '), insert(1, 'err'), text(', '), insert(2, 'result'),
    text(' = pcall('), insert(3), text(', '), insert(4), text(')')
  }
)

local lua_if = snippet(
  { trig = 'if', name = 'if …' },
  {
    text('if '), insert(1), text({ ' then', '\t' }),
    insert(0), text({ '', 'end' })
  }
)

local lua_if_else = snippet(
  { trig = 'ifelse', name = "if … else …" },
  {
    text('if '), insert(1), text({ ' then', '\t' }),
    insert(2), text({ '', 'else', '\t' }),
    insert(0), text({ '', 'end' })
  }
)

local lua_if_elseif = snippet(
  { trig = 'ifelseif', name = 'if … elseif …' },
  {
    text('if '), insert(1), text({ ' then', '\t' }),
    insert(2), text({ '', 'elseif ' }),
    insert(3), text({' then', '\t' }),
    insert(0), text({ '', 'end' })
  }
)

local lua_func = snippet(
  'function',
  {
    text('function '), insert(1), text('('), insert(2), text({ ')', '\t' }),
    insert(0), text({ '', 'end' })
  }
)

---@param trigger string
---@return string
--[[ local function get_line_before_trigger(trigger)
  -- local line = vim.api.nvim_get_current_line()
  local line = luasnip.get_active_snip().env.TM_CURRENT_LINE
  local _, col = unpack(vim.api.nvim_win_get_cursor())
  return line:sub(1, col - #trigger)
end --]]

--[[ local function func_preamble(_args, parent)
  local line_before_trigger = get_line_before_trigger('function')
  if line_before_trigger:match('^%s*$') then
    return node(nil, { text('local function '), insert(1) })
  elseif line_before_trigger:match('^%s*local%s+$') then
    return node(nil, { text('function '), insert(1) })
  else
    return node(nil, { text('function') })
  end
end

local lua_func_dyn = snippet(
  { trig = 'function', name = "local function f() … end" },
  {
    dyn(1, func_preamble, {}),
    text('('), insert(2), text({ ')', '\t' }),
    insert(0), text({ '', 'end' })
  }
)
--]]
local lua_require = snippet(
  'require',
  {
    text("require('"), insert(1), text("')")
  }
)

local lua_local_require = snippet(
  { trig = 'localrequire',
    name = 'local mod = require(\'mod\')',
  },
  {
    text('local '), func(function(nodes)
      local components = vim.split(nodes[1][1], '.', { plain = true, trimempty = true })
      return components[#components]
    end, { 1 }),
    text(" = require('"), insert(1, "mod"), text("')")
  }
)

local js_for_of = snippet(
  { trig = 'forof', name = "for-of loop" },
  {
    text('for ('),
    choice(1, { text('const'), text('let'), text('var') }),
    text(' '), insert(2, 'item'),
    text(' of '), insert(3),
    text({ ') {', '\t' }), insert(0),
    text({ '', '}' })
  }
)

local js_if = snippet(
  { trig = "if", name = "if (…) {…}" },
  { text('if ('), insert(1), text({ ') {', '\t' }),
    insert(0), text({ '', '}', }) }
)

local js_if_else = snippet(
  { trig = "ifelse", name = "if (…) {…} else {…}" },
  { text('if ('), insert(1), text({ ') {', '\t' }), insert(2),
    text({ '', '} else {', '\t' }), insert(0),
    text({ '', '}' }) }
)

luasnip.add_snippets('html', {
  tagpair,
  input, anchor,
  description, doctype, html,
  stylesheet,
})

luasnip.add_snippets('php', {
  php, php_if, php_phpif,
})

luasnip.add_snippets('lua', {
  lua_pairs, lua_ipairs,
  lua_if, lua_if_else, lua_if_elseif,
  lua_pcall,
  lua_require, lua_local_require,
  lua_func,
  snippet({ trig = 'elseif', name = 'elseif … then' },
    { text('elseif '), insert(1), text({ ' then', '\t' }), insert(0) })
})

luasnip.add_snippets('javascript', {
  js_for_of, js_if, js_if_else,
})

luasnip.filetype_extend('typescript', {'javascript'})
luasnip.filetype_extend('php', {'html'})
luasnip.filetype_extend('typescriptreact', {'typescript'})
luasnip.filetype_extend('javascriptreact', {'javascript'})
