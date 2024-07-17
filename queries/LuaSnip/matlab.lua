local ls     = require("luasnip")
local extras = require('luasnip.extras')
local ex_fmt = require('luasnip.extras.fmt')
-- some shorthands...
local s            = ls.snippet
local sn           = ls.snippet_node
local t            = ls.text_node
local i            = ls.insert_node
local f            = ls.function_node
local c            = ls.choice_node
local d            = ls.dynamic_node
local r            = ls.restore_node
local l            = extras.lambda
local rep          = extras.rep
local p            = extras.partial
local m            = extras.match
local n            = extras.nonempty
local dl           = extras.dynamic_lambda
local fmt          = ex_fmt.fmt
local fmta         = ex_fmt.fmta
local types        = require("luasnip.util.types")
local conds        = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")


local snippets, autosnippets = {}, {}

--[docstring] 1) one line doc title
local template_snip = [[
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% {} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{}
]]

local docstring_thin_title = s({
	trig = '%%%',
	name = 'doc - thin title',
	desc = 'docstring in one line title',
	},
	fmt(template_snip, {
		i(1, {'Description'}),
		i(0),
	})
)
table.insert(autosnippets, docstring_thin_title)


--[docstring] 2) triple lines doc title
local template_snip = [[
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% {}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{}
]]

local docstring_thick_title = s({
	trig = '%%/',
	name = 'doc - thick title',
	desc = 'docstring in three lines title',
	},
	fmt(template_snip, {
		i(1, {'Description'}),
		i(0),
	})
)
table.insert(autosnippets, docstring_thick_title)




return snippets, autosnippets

