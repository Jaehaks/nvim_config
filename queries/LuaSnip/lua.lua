local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")


ls.add_snippets("lua", {
	-- require module (duplicate lsp)
	s({
		trig = 'require(module)',
		name = 'require',
		desc = 'require lua module'
	}, {
		t("require(\'"), i(1, 'module'), t('\')')
	}),
	-- local variable declaration
	s({
		trig = 'local var',
		name = 'local variable',
		desc = 'make local variable with value'
	},{
		t('local '), i(1, 'variable'), t(' = '), i(2, 'value')
	}),
	-- local require declaration
	s({
		trig = 'local require',
		name = 'local require',
		desc = 'make local variable with require module'
	},{
		t('local '), i(1, 'variable'), t(' = require(\''), i(2, 'module'), t('\')')
	}),
	-- if statement
	s({
		trig = 'if',
		name = 'if',
		desc = 'if statement'
	},{
		t('if '), i(1, 'true'), t(' then'),
		t({'','\t'}), i(2, '-- code'),
		t({'', 'end'})
	}),
	-- basic for statement
	s({
		trig = 'for i=1:10',
		name = 'for',
		desc = 'basic for statement'
	},{
		t('for '), i(1, 'i'), t(' = '), i(2,'1'), t(' l :'), i(3,'10'), t(' then'),
		t({'','\t'}), i(4, '-- code'),
		t({'', 'end'})
	}),
	-- ipairs for statement
	s({
		trig = 'for ipairs',
		name = 'for ipairs',
		desc = 'ipair for statement'
	},{
		t('for '), i(1, 'i'), t(', '), i(2, 'v'), t(' in ipairs('), i(3,'table'), t(') do'),
		t({'','\t'}), i(4, '-- code'),
		t({'', 'end'})
	}),
	-- pairs for statement
	s({
		trig = 'for pairs',
		name = 'for pairs',
		desc = 'ipair for statement'
	},{
		t('for '), i(1, 'k'), t(', '), i(2, 'v'), t(' in pairs('), i(3,'table'), t(') do'),
		t({'','\t'}), i(0, '-- code'),
		t({'', 'end'})
	}),
	-- while statement
	s({
		trig = 'while',
		name = 'while',
		desc = 'while statement'
	},{
		t('while '), i(1, 'true'), t(' do'),
		t({'','\t'}), i(2, '-- code'),
		t({'', 'end'})
	}),
	-- function inline
	s({
		trig = 'function () inline',
		name = 'function inline',
		desc = 'make anonymous inline function'
	},{
		t('function('), i(1, ''), t(') '), i(2, 'code'), t(' end'),
	}),
	-- -- function comment
	-- s({
	-- 	trig = 'function () comment',
	-- 	name = 'function comment',
	-- 	desc = 'make function with comment'
	-- },{
	-- 	t('-- [[ '), i(1, 'one-line-summary'), t(']]'),
	-- 	t({'', '-- @param '}), i(1,'name'), t(' - '), i(1,'type'), t(' : '), i(1,'description'),
	-- 	t({'', '-- @return '}), i(1,'name'), t(' - '), i(1,'type'), t(' : '), i(1,'description'),
	-- 	t({'','local '}), i(1,' vname'), t(' = function '), i(2, 'fname'), t('('), i(3, 'param'), t(')'),
	-- 	t({'','\t'}), i(4, '-- code'),
	-- 	t({'', 'end'})
	-- }),
})


local function add_param(args)
	local param_str = args[1][1]
	param_str = param_str:gsub(' ','') 	-- remove blank
	if param_str == '' then return '' end -- if there is no param, return

	local params = vim.split(param_str, ',') -- make table after spliting parameter
	local doc_comments = {''}
	for _, param in ipairs(params) do -- add param string to doc_comments table
		table.insert(
			doc_comments,
			string.format('-- @param %s - type : description', param)
		)
	end

	return doc_comments
end

local func_template = [==[
-- [[@function : {}]]{}
function {}({})
	{}
end
]==]

-- https://www.youtube.com/watch?v=xxNZoFk7jtw
-- it has half funciton, it returns the comment after all parameters are entered, 
-- need realtime comment
ls.add_snippets('lua', {
	s('function () comment',
		fmt(func_template, {
			i(1, 'one-line-summary'),
			f(add_param, {3}),
			i(2, 'fname'), i(3, 'params'),
			i(4, '-- code')
		}))
})
