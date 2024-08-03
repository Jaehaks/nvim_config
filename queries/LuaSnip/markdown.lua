local ls     = require("luasnip")
-- some shorthands...
local s            = ls.snippet
local t            = ls.text_node
local i            = ls.insert_node


local snippets, autosnippets = {}, {}

-- 1) make code block
local code_block = s({
	trig = '```',
	name = 'code block',
	desc = 'make code block',
	}, {
	t({'```'}), i(1,'filetype'),
	t({'','\t'}), i(2, '-- code'),
	t({'','```'}),
	t({'',''}), i(0,'')
})
table.insert(autosnippets, code_block)





return snippets, autosnippets
