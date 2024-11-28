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
]]

local begin_end = s({
	trig = '\\beg',
	name = 'begin ~ end',
	desc = 'begin ~ end',
	},
	fmt(temp_fmt, {
		i(1, 'env'),
		i(2),
		f(function(args)
			return args[1][1]
		end,{1}),
	})
)
table.insert(autosnippets, begin_end)


-- [equation] 1) left - right
temp_fmt = [[
\left{} {} \right{}
]]

local left_right = s({
	trig = '\\lef',
	name = 'left ~ right',
	desc = 'left ~ right',
	},
	fmt(temp_fmt, {
		i(1),
		i(2),
		f(function (args)
			local str = args[1][1]
			local delim = str:sub(1,1) -- get first char
			local char1 = ''
			local out = ''

			-- check first char is '\'
			if delim == '\\' then
				delim = str:sub(2,2)	-- get second char
				char1 = '\\'
			end

			-- add right symbol
			if delim == '(' then out = ')'
			elseif delim == '{' then out = '}'
			elseif delim == '[' then out = ']'
			elseif delim == '<' then out = '>'
			else out = ''
			end

			return char1 .. out
		end,{1}),
	})
)
table.insert(autosnippets, left_right)


-- [equation] 2) fractional number
temp_fmt = [[
\frac{{{}}}{{{}}}
]]

local frac = s({
	trig = '\\frac',
	name = 'frac{}{}',
	desc = 'frac{}{}',
	},
	fmt(temp_fmt, {
		i(1),
		i(2),
	})
)
table.insert(snippets, frac)

temp_fmt = [[
\dfrac{{{}}}{{{}}}
]]

local dfrac = s({
	trig = '\\dfrac',
	name = 'dfrac{}{}',
	desc = 'dfrac{}{}',
	},
	fmt(temp_fmt, {
		i(1),
		i(2),
	})
)
table.insert(snippets, dfrac)


-- [equation] 3) bmatrix 2x2
temp_fmt = [[
\begin{{bmatrix}}
	{} & {} \\
	{} & {} \\
\end{{bmatrix}}
]]

local mat = s({
	trig = '\\matrix',
	name = 'bmatrix 2x2',
	desc = 'bmatrix 2x2',
	},
	fmt(temp_fmt, {
		i(1),
		i(2),
		i(3),
		i(4),
	})
)
table.insert(snippets, mat)



-- [equation] 4) vector 2x1
temp_fmt = [[
\begin{{bmatrix}}
	{} \\
	{} \\
\end{{bmatrix}}
]]

local vect = s({
	trig = '\\vector',
	name = 'vector 2x1',
	desc = 'vector 2x1',
	},
	fmt(temp_fmt, {
		i(1),
		i(2),
	})
)
table.insert(snippets, vect)


-- [doc] 1) title doc
temp_fmt = [[
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% {}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{}
]]

local title = s({
	trig = '\\doc',
	name = 'doc title',
	desc = 'doc title',
	},
	fmt(temp_fmt, {
		i(1),
		i(2),
	})
)
table.insert(snippets, title)






return snippets, autosnippets

