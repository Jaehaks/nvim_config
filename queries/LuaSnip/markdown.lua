local ls     = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

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

-- 2) make callout
local callout = s({
	trig = ']!',
	name = 'callout',
	desc = 'select callout',
	}, {
	t({'> [!'}),
	c(1,{
		t('NOTE'),
		t('IMPORTANT'),
		t('CAUTION'),
		t('TIP'),
		t('TODO'),
		t('ABSTRACT'),
		t('EXAMPLE'),
		t('SUCCESS'),
		t('FAILURE'),
		t('WARNING'),
		t('BUG'),
		t('QUESTION'),
		t('DANGER'),
		t('BUG'),
		t('QUOTE'),
	}),
	t({']',''}),
	t({'> '}), i(0,'')
})
table.insert(autosnippets, callout)




return snippets, autosnippets
