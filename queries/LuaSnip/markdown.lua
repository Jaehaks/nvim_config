local ls     = require("luasnip")
local ex_fmt = require('luasnip.extras.fmt')
-- some shorthands...
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local c   = ls.choice_node
local f   = ls.function_node
local fmt = ex_fmt.fmt

local snippets, autosnippets = {}, {}

-- make code block
local code_block = s({
	trig = '```',
	name = 'code block',
	desc = 'make code block',
	}, {
	t({'```'}), i(1,'filetype'),
	t({'',''}), i(2, '-- code'),
	t({'','```'}),
	t({'',''}), i(0,'')
})
table.insert(autosnippets, code_block)

-- make callout
local callout_list = {
	t('NOTE'),
	t('ABSTRACT'),
	t('ATTENTION'),
	t('SUMMARY'),
	t('SUCCESS'),
	t('DONE'),
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
	t('TLDR'),
	t('INFO'),
	t('TODO'),
	t('CAUTION'),
	t('FAIL'),
	t('MISSING'),
	t('WARNING'),
	t('DANGER'),
	t('ERROR'),
	t('BUG'),
	t('MISSING'),
}
local callout_title = function (args)
	local title = args[1][1]

	return string.sub(title,1,1) .. string.lower(string.sub(title,2)) .. ': '
end

local callout = s({
	trig = ']!',
	name = 'callout',
	desc = 'select callout',
	}, {
	t({'> [!'}),
	c(1, callout_list),
	t({'] '}),
	f(callout_title, {1}, {}),
	i(2,''),
	t({'', ''}),
	t({'> '}), i(0,'')
})
table.insert(autosnippets, callout)

-- make folding in github
local template_details = [[
<details>
	<summary> {} </summary>

<br>

{}

</details>
{}
]]

local details = s({
	trig = 'details{}',
	name = 'folding',
	desc = 'folding section in markdown for github',
	}, fmt(template_details, {
		i(1, 'SummaryTitle'),
		i(2, 'Contents ..'),
		i(0, ''),
	})
)
table.insert(snippets, details)



return snippets, autosnippets
