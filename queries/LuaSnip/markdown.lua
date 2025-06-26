local ls     = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

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
local callout_list = {
	t('NOTE'),
	t('ABSTRACT'),
	t('SUMMARY'),
	t('CHECK'),
	t('IMPORTANT'),
	t('EXAMPLE'),
	t('QUESTION'),
	t('ANSWER'),
	t('FAQ'),
	t('HELP'),
	t('QUOTE'),
	t('CITE'),
	t('TIP'),
	t('HINT'),
	t('INFO'),
	t('TODO'),
	t('CAUTION'),
	t('WARNING'),
	t('DANGER'),
	t('MISSING'),
}

local callout = s({
	trig = ']!',
	name = 'callout',
	desc = 'select callout',
	}, {
	t({'> [!'}),
	c(1, callout_list),
	t({']',''}),
	t({'> '}), i(0,'')
})
table.insert(autosnippets, callout)




return snippets, autosnippets
