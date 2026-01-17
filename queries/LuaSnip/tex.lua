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


-- -- [section] 1) begin-end
-- local temp_fmt = [[
-- \begin{{{}}}
-- 	{}
-- \end{{{}}}
-- ]]
--
-- local begin_end = s({
-- 	trig = '\\beg',
-- 	name = 'begin ~ end',
-- 	desc = 'begin ~ end',
-- 	},
-- 	fmt(temp_fmt, {
-- 		i(1, 'env'),
-- 		i(2),
-- 		f(function(args)
-- 			return args[1][1]
-- 		end,{1}),
-- 	})
-- )
-- table.insert(snippets, begin_end)


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
table.insert(snippets, left_right)


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


-- [paren] 1) square_brackets
temp_fmt = [[
\[ {} \]
]]

local square_brackets = s({
	trig = '\\[',
	name = 'square_brackets',
	desc = 'square_brackets',
	},
	fmt(temp_fmt, {
		i(1),
	})
)
table.insert(autosnippets, square_brackets)

-- [paren] 2)brace
temp_fmt = [[
\{{ {} \}}
]]

local brace = s({
	trig = '\\{',
	name = 'brace',
	desc = 'brace',
	},
	fmt(temp_fmt, {
		i(1),
	})
)
table.insert(autosnippets, brace)

-- [paren] 3)round paren
temp_fmt = [[
\( {} \)
]]

local round_paren = s({
	trig = '\\(',
	name = 'round_paren',
	desc = 'round_paren',
	},
	fmt(temp_fmt, {
		i(1),
	})
)
table.insert(autosnippets, round_paren)





-- [keyword] stator current
local iass     = s({ trig = 'iass',     name = 'iass',     desc = 'iass'},     t({'i_{\\alpha s}^s'}))
local ibss     = s({ trig = 'ibss',     name = 'ibss',     desc = 'ibss'},     t({'i_{\\beta s}^s'}))

local idss     = s({ trig = 'idss',     name = 'idss',     desc = 'idss'},     t({'i_{ds}^s'}))
local iqss     = s({ trig = 'iqss',     name = 'iqss',     desc = 'iqss'},     t({'i_{qs}^s'}))

local idse     = s({ trig = 'idse',     name = 'idse',     desc = 'idse'},     t({'i_{ds}^e'}))
local iqse     = s({ trig = 'iqse',     name = 'iqse',     desc = 'iqse'},     t({'i_{qs}^e'}))
local idseh    = s({ trig = 'idseh',    name = 'idseh',    desc = 'idseh'},    t({'i_{ds}^{\\hat{e}}'}))
local iqseh    = s({ trig = 'iqseh',    name = 'iqseh',    desc = 'iqseh'},    t({'i_{qs}^{\\hat{e}}'}))

local idsr     = s({ trig = 'idsr',     name = 'idsr',     desc = 'idsr'},     t({'i_{ds}^r'}))
local iqsr     = s({ trig = 'iqsr',     name = 'iqsr',     desc = 'iqsr'},     t({'i_{qs}^r'}))
local idsrh    = s({ trig = 'idsrh',    name = 'idsrh',    desc = 'idsrh'},    t({'i_{ds}^{\\hat{r}}'}))
local iqsrh    = s({ trig = 'iqsrh',    name = 'iqsrh',    desc = 'iqsrh'},    t({'i_{qs}^{\\hat{r}}'}))

-- [keyword] rotor current
local iars     = s({ trig = 'iars',     name = 'iars',     desc = 'iars'},     t({'i_{\\alpha r}^s'}))
local ibrs     = s({ trig = 'ibrs',     name = 'ibrs',     desc = 'ibrs'},     t({'i_{\\beta r}^s'}))

local idrs     = s({ trig = 'idrs',     name = 'idrs',     desc = 'idrs'},     t({'i_{dr}^s'}))
local iqrs     = s({ trig = 'iqrs',     name = 'iqrs',     desc = 'iqrs'},     t({'i_{qr}^s'}))

local idre     = s({ trig = 'idre',     name = 'idre',     desc = 'idre'},     t({'i_{dr}^e'}))
local iqre     = s({ trig = 'iqre',     name = 'iqre',     desc = 'iqre'},     t({'i_{qr}^e'}))
local idreh    = s({ trig = 'idreh',    name = 'idreh',    desc = 'idreh'},    t({'i_{dr}^{\\hat{e}}'}))
local iqreh    = s({ trig = 'iqreh',    name = 'iqreh',    desc = 'iqreh'},    t({'i_{qr}^{\\hat{e}}'}))

local idrr     = s({ trig = 'idrr',     name = 'idrr',     desc = 'idrr'},     t({'i_{dr}^r'}))
local iqrr     = s({ trig = 'iqrr',     name = 'iqrr',     desc = 'iqrr'},     t({'i_{qr}^r'}))
local idrrh    = s({ trig = 'idrrh',    name = 'idrrh',    desc = 'idrrh'},    t({'i_{dr}^{\\hat{r}}'}))
local iqrrh    = s({ trig = 'iqrrh',    name = 'iqrrh',    desc = 'iqrrh'},    t({'i_{qr}^{\\hat{r}}'}))


-- [keyword] stator voltage
local vass     = s({ trig = 'vass',     name = 'vass',     desc = 'vass'},     t({'v_{\\alpha s}^s'}))
local vbss     = s({ trig = 'vbss',     name = 'vbss',     desc = 'vbss'},     t({'v_{\\beta s}^s'}))

local vdss     = s({ trig = 'vdss',     name = 'vdss',     desc = 'vdss'},     t({'v_{ds}^s'}))
local vqss     = s({ trig = 'vqss',     name = 'vqss',     desc = 'vqss'},     t({'v_{qs}^s'}))

local vdse     = s({ trig = 'vdse',     name = 'vdse',     desc = 'vdse'},     t({'v_{ds}^e'}))
local vqse     = s({ trig = 'vqse',     name = 'vqse',     desc = 'vqse'},     t({'v_{qs}^e'}))
local vdseh    = s({ trig = 'vdseh',    name = 'vdseh',    desc = 'vdseh'},    t({'v_{ds}^{\\hat{e}}'}))
local vqseh    = s({ trig = 'vqseh',    name = 'vqseh',    desc = 'vqseh'},    t({'v_{qs}^{\\hat{e}}'}))

local vdsr     = s({ trig = 'vdsr',     name = 'vdsr',     desc = 'vdsr'},     t({'v_{ds}^r'}))
local vqsr     = s({ trig = 'vqsr',     name = 'vqsr',     desc = 'vqsr'},     t({'v_{qs}^r'}))
local vdsrh    = s({ trig = 'vdsrh',    name = 'vdsrh',    desc = 'vdsrh'},    t({'v_{ds}^{\\hat{r}}'}))
local vqsrh    = s({ trig = 'vqsrh',    name = 'vqsrh',    desc = 'vqsrh'},    t({'v_{qs}^{\\hat{r}}'}))

-- [keyword] rotor voltage
local vars     = s({ trig = 'vars',     name = 'vars',     desc = 'vars'},     t({'v_{\\alpha r}^s'}))
local vbrs     = s({ trig = 'vbrs',     name = 'vbrs',     desc = 'vbrs'},     t({'v_{\\beta r}^s'}))

local vdrs     = s({ trig = 'vdrs',     name = 'vdrs',     desc = 'vdrs'},     t({'v_{dr}^s'}))
local vqrs     = s({ trig = 'vqrs',     name = 'vqrs',     desc = 'vqrs'},     t({'v_{qr}^s'}))

local vdre     = s({ trig = 'vdre',     name = 'vdre',     desc = 'vdre'},     t({'v_{dr}^e'}))
local vqre     = s({ trig = 'vqre',     name = 'vqre',     desc = 'vqre'},     t({'v_{qr}^e'}))
local vdreh    = s({ trig = 'vdreh',    name = 'vdreh',    desc = 'vdreh'},    t({'v_{dr}^{\\hat{e}}'}))
local vqreh    = s({ trig = 'vqreh',    name = 'vqreh',    desc = 'vqreh'},    t({'v_{qr}^{\\hat{e}}'}))

local vdrr     = s({ trig = 'vdrr',     name = 'vdrr',     desc = 'vdrr'},     t({'v_{dr}^r'}))
local vqrr     = s({ trig = 'vqrr',     name = 'vqrr',     desc = 'vqrr'},     t({'v_{qr}^r'}))
local vdrrh    = s({ trig = 'vdrrh',    name = 'vdrrh',    desc = 'vdrrh'},    t({'v_{dr}^{\\hat{r}}'}))
local vqrrh    = s({ trig = 'vqrrh',    name = 'vqrrh',    desc = 'vqrrh'},    t({'v_{qr}^{\\hat{r}}'}))

-- [keyword] stator flux
local lambdss  = s({ trig = 'lambdss',  name = 'lambdss',  desc = 'lambdss'},  t({'\\lambda_{ds}^s'}))
local lambqss  = s({ trig = 'lambqss',  name = 'lambqss',  desc = 'lambqss'},  t({'\\lambda_{qs}^s'}))
local lambdssh = s({ trig = 'lambdssh', name = 'lambdssh', desc = 'lambdssh'}, t({'\\lambda_{ds}^{\\hat{s}}'}))
local lambqssh = s({ trig = 'lambqssh', name = 'lambqssh', desc = 'lambqssh'}, t({'\\lambda_{qs}^{\\hat{s}}'}))

local lambdse  = s({ trig = 'lambdse',  name = 'lambdse',  desc = 'lambdse'},  t({'\\lambda_{ds}^e'}))
local lambqse  = s({ trig = 'lambqse',  name = 'lambqse',  desc = 'lambqse'},  t({'\\lambda_{qs}^e'}))
local lambdseh = s({ trig = 'lambdseh', name = 'lambdseh', desc = 'lambdseh'}, t({'\\lambda_{ds}^{\\hat{e}}'}))
local lambqseh = s({ trig = 'lambqseh', name = 'lambqseh', desc = 'lambqseh'}, t({'\\lambda_{qs}^{\\hat{e}}'}))

local lambdsr  = s({ trig = 'lambdsr',  name = 'lambdsr',  desc = 'lambdsr'},  t({'\\lambda_{ds}^r'}))
local lambqsr  = s({ trig = 'lambqsr',  name = 'lambqsr',  desc = 'lambqsr'},  t({'\\lambda_{qs}^r'}))
local lambdsrh = s({ trig = 'lambdsrh', name = 'lambdsrh', desc = 'lambdsrh'}, t({'\\lambda_{ds}^{\\hat{r}}'}))
local lambqsrh = s({ trig = 'lambqsrh', name = 'lambqsrh', desc = 'lambqsrh'}, t({'\\lambda_{qs}^{\\hat{r}}'}))

-- [keyword] rotor flux
local lambdrs  = s({ trig = 'lambdrs',  name = 'lambdrs',  desc = 'lambdrs'},  t({'\\lambda_{dr}^s'}))
local lambqrs  = s({ trig = 'lambqrs',  name = 'lambqrs',  desc = 'lambqrs'},  t({'\\lambda_{qr}^s'}))
local lambdrsh = s({ trig = 'lambdrsh', name = 'lambdrsh', desc = 'lambdrsh'}, t({'\\lambda_{dr}^{\\hat{s}}'}))
local lambqrsh = s({ trig = 'lambqrsh', name = 'lambqrsh', desc = 'lambqrsh'}, t({'\\lambda_{qr}^{\\hat{s}}'}))

local lambdre  = s({ trig = 'lambdre',  name = 'lambdre',  desc = 'lambdre'},  t({'\\lambda_{dr}^e'}))
local lambqre  = s({ trig = 'lambqre',  name = 'lambqre',  desc = 'lambqre'},  t({'\\lambda_{qr}^e'}))
local lambdreh = s({ trig = 'lambdreh', name = 'lambdreh', desc = 'lambdreh'}, t({'\\lambda_{dr}^{\\hat{e}}'}))
local lambqreh = s({ trig = 'lambqreh', name = 'lambqreh', desc = 'lambqreh'}, t({'\\lambda_{qr}^{\\hat{e}}'}))

local lambdrr  = s({ trig = 'lambdrr',  name = 'lambdrr',  desc = 'lambdrr'},  t({'\\lambda_{dr}^r'}))
local lambqrr  = s({ trig = 'lambqrr',  name = 'lambqrr',  desc = 'lambqrr'},  t({'\\lambda_{qr}^r'}))
local lambdrrh = s({ trig = 'lambdrrh', name = 'lambdrrh', desc = 'lambdrrh'}, t({'\\lambda_{dr}^{\\hat{r}}'}))
local lambqrrh = s({ trig = 'lambqrrh', name = 'lambqrrh', desc = 'lambqrrh'}, t({'\\lambda_{qr}^{\\hat{r}}'}))

local psim  = s({ trig = 'psim',  name = 'psim',  desc = 'psim'},  t({'\\psi_{m}'}))

-- [keyword] other
local Wsl      = s({ trig = 'wsl',      name = 'wsl',      desc = 'wsl'},      t({'\\omega_{sl}'}))
local We       = s({ trig = 'we',       name = 'we',       desc = 'we'},       t({'\\omega_{e}'}))
local Wr       = s({ trig = 'wr',       name = 'wr',       desc = 'wr'},       t({'\\omega_{r}'}))
local Tr       = s({ trig = 'tr',       name = 'tr',       desc = 'tr'},       t({'\\tau_{r}'}))
local InvTr    = s({ trig = 'invtr',    name = 'invtr',    desc = 'invtr'},    t({'\\frac{1}{\\tau_r}'}))
local Trh      = s({ trig = 'trh',      name = 'trh',      desc = 'trh'},      t({'\\hat{\\tau}_r'}))
local InvTrh   = s({ trig = 'invtrh',   name = 'invtrh',   desc = 'invtrh'},   t({'\\frac{1}{\\hat{\\tau}_r}'}))


table.insert(snippets, iass)
table.insert(snippets, ibss)
table.insert(snippets, idss)
table.insert(snippets, iqss)
table.insert(snippets, idse)
table.insert(snippets, iqse)
table.insert(snippets, idseh)
table.insert(snippets, iqseh)
table.insert(snippets, idsr)
table.insert(snippets, iqsr)
table.insert(snippets, idsrh)
table.insert(snippets, iqsrh)

table.insert(snippets, iars)
table.insert(snippets, ibrs)
table.insert(snippets, idrs)
table.insert(snippets, iqrs)
table.insert(snippets, idre)
table.insert(snippets, iqre)
table.insert(snippets, idreh)
table.insert(snippets, iqreh)
table.insert(snippets, idrr)
table.insert(snippets, iqrr)
table.insert(snippets, idrrh)
table.insert(snippets, iqrrh)

table.insert(snippets, vass)
table.insert(snippets, vbss)
table.insert(snippets, vdss)
table.insert(snippets, vqss)
table.insert(snippets, vdse)
table.insert(snippets, vqse)
table.insert(snippets, vdseh)
table.insert(snippets, vqseh)
table.insert(snippets, vdsr)
table.insert(snippets, vqsr)
table.insert(snippets, vdsrh)
table.insert(snippets, vqsrh)

table.insert(snippets, vars)
table.insert(snippets, vbrs)
table.insert(snippets, vdrs)
table.insert(snippets, vqrs)
table.insert(snippets, vdre)
table.insert(snippets, vqre)
table.insert(snippets, vdreh)
table.insert(snippets, vqreh)
table.insert(snippets, vdrr)
table.insert(snippets, vqrr)
table.insert(snippets, vdrrh)
table.insert(snippets, vqrrh)

table.insert(snippets, lambdss)
table.insert(snippets, lambqss)
table.insert(snippets, lambdssh)
table.insert(snippets, lambqssh)
table.insert(snippets, lambdse)
table.insert(snippets, lambqse)
table.insert(snippets, lambdseh)
table.insert(snippets, lambqseh)
table.insert(snippets, lambdsr)
table.insert(snippets, lambqsr)
table.insert(snippets, lambdsrh)
table.insert(snippets, lambqsrh)

table.insert(snippets, lambdrs)
table.insert(snippets, lambqrs)
table.insert(snippets, lambdrsh)
table.insert(snippets, lambqrsh)
table.insert(snippets, lambdre)
table.insert(snippets, lambqre)
table.insert(snippets, lambdreh)
table.insert(snippets, lambqreh)
table.insert(snippets, lambdrr)
table.insert(snippets, lambqrr)
table.insert(snippets, lambdrrh)
table.insert(snippets, lambqrrh)

table.insert(snippets, psim)

table.insert(snippets, Wsl)
table.insert(snippets, We)
table.insert(snippets, Wr)
table.insert(snippets, Tr)
table.insert(snippets, InvTr)
table.insert(snippets, Trh)
table.insert(snippets, InvTrh)



return snippets, autosnippets

