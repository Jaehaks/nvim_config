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
template_snip = [[
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



--[function] default function
template_snip = [[
function [ {} ] = {}({})
	{}
end
{}
]]

local function_empty = s({
	trig = 'function',
	name = 'function - empty',
	desc = 'minimalistic function declaration',
	},
	fmt(template_snip,{
		i(1, {'A, B, C'}), i(2, {'myFunc'}), i(3, {'a, b, c'}),
		i(4, {'% code'}),
		i(0)
	})
)
table.insert(snippets, function_empty)


--[loop] for 1 level
template_snip = [[
for {} = {} : {}
	{}
end
{}
]]

local for1 = s({
	trig = 'for1',
	name = 'for 1 level',
	desc = '1 level for loop',
	},
	fmt(template_snip,{
		i(1, {'n'}), i(2, {'1'}), i(3, {'len'}),
		i(4, {'% code'}),
		i(0)
	})
)
table.insert(snippets, for1)

--[loop] for 2 level
template_snip = [[
for {} = {} : {}
	for {} = {} : {}
		{}
	end
end
{}
]]

local for2 = s({
	trig = 'for2',
	name = 'for 2 level',
	desc = '2 level for loop',
	},
	fmt(template_snip,{
		i(1, {'n'}), i(2, {'1'}), i(3, {'len1'}),
		i(4, {'m'}), i(5, {'1'}), i(6, {'len2'}),
		i(7, {'% code'}),
		i(0)
	})
)
table.insert(snippets, for2)


--[loop] while 1 level
template_snip = [[
while {} {} {}
	{}
end
{}
]]

local while1 = s({
	trig = 'while1',
	name = 'while 1 level',
	desc = '1 level while loop',
	},
	fmt(template_snip,{
		i(1, {'n'}), i(2, {'<='}), i(3, {'len1'}),
		i(4, {'% code'}),
		i(0)
	})
)
table.insert(snippets, while1)


--[if] if only
template_snip = [[
if {} {} {}
	{}
end
{}
]]

local ifonly = s({
	trig = 'ifonly',
	name = 'if only statement',
	desc = 'junction with only if',
	},
	fmt(template_snip,{
		i(1, {'n'}), i(2, {'=='}), i(3, {'len1'}),
		i(4, {'% code'}),
		i(0)
	})
)
table.insert(snippets, ifonly)


--[if] if - else
template_snip = [[
if {} {} {}
	{}
else
	{}
end
{}
]]

local ifelse = s({
	trig = 'ifelse',
	name = 'if - else statement',
	desc = 'junction with if - else',
	},
	fmt(template_snip,{
		i(1, {'n'}), i(2, {'=='}), i(3, {'len1'}),
		i(4, {'% if code'}),
		i(5, {'% else code'}),
		i(0)
	})
)
table.insert(snippets, ifelse)


--[if] if - elseif - else
template_snip = [[
if {} {} {}
	{}
elseif {} {} {}
	{}
else
	{}
end
{}
]]

local ifelif = s({
	trig = 'ifelif',
	name = 'if - elseif - else statement',
	desc = 'junction with if - elseif - else',
	},
	fmt(template_snip,{
		i(1, {'n'}), i(2, {'=='}), i(3, {'len1'}),
		i(4, {'% if code'}),
		i(5, {'m'}), i(6, {'=='}), i(7, {'len2'}),
		i(8, {'% else if code'}),
		i(9, {'% else code'}),
		i(0)
	})
)
table.insert(snippets, ifelif)


--[plot] figure format
template_snip = [[
{} = figure({});
{}.Name = {};

{}

set({}, "color", "w");
]]

local fig_default = s({
	trig = 'figdef',
	name = 'default figure form',
	desc = 'basic figure form',
	},
	fmt(template_snip,{
		i(1, {'f1'}), i(2, {'fig_id'}),
		l(l._1, {1}), i(3, {'fig_name'}),
		i(0),
		l(l._1, {1})
	})
)
table.insert(snippets, fig_default)


--[plot] figure maximize
template_snip = [[
{} = figure({});
{}.Name = {};

{}

set({}, "color", "w");
set({}, "outerposition", get(0, "screensize"));
set({}, "WindowState", "maximized");
]]

local fig_maximize = s({
	trig = 'figmax',
	name = 'maximize figure',
	desc = 'maximize figure',
	},
	fmt(template_snip,{
		i(1, {'f1'}), i(2, {'fig_id'}),
		l(l._1, {1}), i(3, {'fig_name'}),
		i(0),
		l(l._1, {1}),
		l(l._1, {1}),
		l(l._1, {1}),
	})
)
table.insert(snippets, fig_maximize)


--[plot] plot
template_snip = [[
plot({}, {}, {});
{}
]]

local plot = s({
	trig = 'plot',
	name = 'basic plot',
	desc = 'default plot',
	},
	fmt(template_snip,{
		i(1, {'x_array'}), i(2, {'y_array'}), i(3, {'-'}),
		i(0)
	})
)
table.insert(snippets, plot)


--[plot] subplot
template_snip = [[
subplot({},{},{}); hold on; grid on;
{}
]]

local subplot = s({
	trig = 'subplot',
	name = 'basic subplot',
	desc = 'default subplot',
	},
	fmt(template_snip,{
		i(1, {'1'}), i(2, {'2'}), i(3, {'1'}),
		i(0)
	})
)
table.insert(snippets, subplot)


--[plot] label
template_snip = [[
xlabel({});
ylabel({});
title({});
{}
]]

local label = s({
	trig = 'label',
	name = 'default label set',
	desc = 'default label set',
	},
	fmt(template_snip,{
		i(1, {"'xlabel'"}),
		i(2, {"'ylabel'"}),
		i(3, {"[title]"}),
		i(0)
	})
)
table.insert(snippets, label)


--[plot] legend
template_snip = [[
legend({}, "Location", "best")
{}
]]

local legend = s({
	trig = 'legend',
	name = 'default label set',
	desc = 'default label set',
	},
	fmt(template_snip,{
		i(1, {'leg1'}),
		i(0)
	})
)
table.insert(snippets, legend)


--[find] find first
template_snip = [[
{} = find({}, {}, {})
{}
]]

local find_first = s({
	trig = 'findfirst',
	name = 'default find first',
	desc = 'default find first command',
	},
	fmt(template_snip,{
		i(1, {'var'}), i(2, {'condition'}), i(3, {'1'}), i(4, {'"First"'}),
		i(0)
	})
)
table.insert(snippets, find_first)


--[find] find default
template_snip = [[
{} = find({})
{}
]]

local find_default = s({
	trig = 'finddef',
	name = 'default find',
	desc = 'default find command',
	},
	fmt(template_snip,{
		i(1, {'var'}), i(2, {'condition'}),
		i(0)
	})
)
table.insert(snippets, find_default)



return snippets, autosnippets

