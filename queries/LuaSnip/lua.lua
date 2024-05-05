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
local User_Luasnip = vim.api.nvim_create_augroup('User_Luasnip', {clear = true})
local ft = '*.lua'

-- make snippet work only out of comment region
-- local CheckComment = function()
-- 		local context = require('cmp.config.context')
-- 		return not (context.in_treesitter_capture('comment') or context.in_syntax_group('Comment'))
-- 	end

-- [function] 1) empty
local function_empty = s({
	trig = 'fun#e',
	name = 'funciton ()',
	desc = 'make empty argument function',
	-- condition = CheckComment
	}, {
	t({'function ('}), i(1), t({')'}),
	t({'','\t'}), i(2, '-- code'),
	t({'', 'end'}),
	t({'',''}), i(0,'')
})
table.insert(autosnippets, function_empty)

-- [function] 2) empty inline
local function_empty_inline = s({
	trig = 'fun#i',
	name = 'funciton() end',
	desc = 'make empty argument inline function',
	-- condition = CheckComment
	}, {
	t({'function() '}),  i(1, '-- code'), t({' end'}),
	t({'',''}), i(0,'')
})
table.insert(autosnippets, function_empty_inline)



-- [function] 3) with comment
local template_snip = [[
-- {}{} 
local {} = function ({})
	{}
end
{}
]]

local function_comment = s({
	trig = 'fun#c',
	name = 'full funciton()',
	desc = 'make full argument function and comment',
	},
	fmt(template_snip, {
		i(5, {'Desciption'}),
		d(4, function(args)
			local param_str = args[1][1] -- get all param string
			param_str = param_str:gsub(' ', '') -- delete space
			if param_str == '' then
				return sn(1, {t('')})	-- if there are no param, don't show comment about it 
			end
			local params = vim.split(param_str, ',') -- make param_str to table with separator
			local nodes = {}
			for index, param in ipairs(params) do
				table.insert(
					nodes,
					sn(
						index,
						fmt('\n\n-- @param {} <{}> : {}', { -- I don't know why \n must be duplicated to make new line
							t(param),
							i(1, 'type'),
							i(2, 'description')
						})
					)
				)
			end
			return sn(nil, nodes)
		end, {2}),
		i(1, 'name'),
		i(2),
		i(3, '-- code'),
		i(0)
	})
)
table.insert(autosnippets, function_comment)

















return snippets, autosnippets

-- cautions!)
-- 1) if fmt is used as the second argument, you shouldn't surround it with braces 
