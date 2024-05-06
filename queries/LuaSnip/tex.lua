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


-- [section] 1) begin-end
local temp_fmt = [[
\begin{{{}}}
	{}
\end{{{}}}
{}
]]

local begin_end = s({
	trig = '\\begin',
	name = 'begin ~ end',
	desc = 'begin ~ end',
	},
	fmt(temp_fmt, {
		i(1, 'env'),
		i(2),
		f(function(args)
			return args[1][1]
		end,{1}),
		i(0),
	})
)
table.insert(autosnippets, begin_end)

















return snippets, autosnippets

