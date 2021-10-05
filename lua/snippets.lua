local luasnip = require('luasnip')

local snippet = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node
local choice = luasnip.choice_node
local func = luasnip.function_node
local node = luasnip.snippet_node

local tagpair = snippet(
  {
    trig = "<([%w_-]+)>",
    name = "HTML/XML tag pair",
    wordTrig = false,
    regTrig = true,
  },
  {
    luasnip.function_node(function (args)
      return '<' .. args[#args].captures[1] .. '>'
    end, {}),
    luasnip.text_node({ '', '\t' }),
    luasnip.insert_node(1),
    luasnip.text_node({ '', '' }),
    luasnip.function_node(function (args)
      return '</' .. args[#args].captures[1] .. '>'
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
      '\t<body>', '\t\t' }), insert(3), text({ '\t</body>', '</html>' })
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
  'php-if',
  {
    text('<?php if ( '), insert(1), text(' ) : ?>'),
    text({ '', '\t' }), insert(2),
    text({ '', '<?php endif; ?>' }),
  }
)

local lua_pairs = snippet(
  'for-pairs',
  {
    text('for '), insert(1, 'key'), text(', '), insert(2, 'value'),
    text(' in pairs('), insert(3), text({ ') do', '', '\t' }),
    insert(4), text({ '', 'end' })
  }
)

local lua_ipairs = snippet(
  'for-ipairs',
  {
    text('for '), insert(1, 'index'), text(', '), insert(2, 'value'),
    text(' in ipairs('), insert(3), text({ ') do', '\t' }),
    insert(4), text({ '', 'end' })
  }
)

local lua_if = snippet(
  'if',
  {
    text('if '), insert(1), text({ ' then', '\t' }),
    insert(2), text({ '', 'end', '' })
  }
)

local lua_if_else = snippet(
  'if-else',
  {
    text('if '), insert(1), text({ ' then', '\t' }),
    insert(2), text({ '', 'else', '\t' }),
    insert(3), text({ '', 'end', '' })
  }
)

local js_for_of = snippet(
  'for-of',
  {
    text('for ('),
    choice(1, { text('const'), text('let'), text('var') }),
    text(' '), insert(2, 'item'),
    text(' of '), insert(3),
    text({ ') {', '\t' }), insert(4),
    text({ '', '}', '' }), insert(0),
  }
)

local js_if = snippet(
  { trig = "if", name = "if (…) {…}" },
  { text('if ('), insert(1), text({ ') {', '\t' }), insert(2), text({ '', '}', '' }) }
)

local js_if_else = snippet(
  { trig = "if-else", name = "if (…) {…} else {…}" },
  { text('if ('), insert(1), text({ ') {', '\t' }), insert(2),
    text({ '', '} else {', '\t' }), insert(3),
    text({ '', '}', '' }) }
)

luasnip.snippets = {
  html = {
    tagpair,
    input, anchor,
    description, doctype, html,
  },
  php = {
    php, php_if,
  },
  xml = {
    tagpair,
  },
  lua = {
    lua_pairs, lua_ipairs,
    lua_if, lua_if_else,
  },
  javascript = {
    js_for_of, js_if, js_if_else,
  },
  typescript = {},
}

for _, snip in ipairs(luasnip.snippets.javascript) do
  table.insert(luasnip.snippets.typescript, snip)
end

for _, snip in ipairs(luasnip.snippets.html) do
  table.insert(luasnip.snippets.php, snip)
end
