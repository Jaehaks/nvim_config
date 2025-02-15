return {
{
	'numToStr/Comment.nvim',
	keys = {
		{'gl', mode = {'n', 'v'}},
		{'gb', mode = {'n', 'v'}},
		{'gL'},
	},
	opts = {
		toggler = {
			line  = 'gl',
			block = 'gb',
		},
		opleader = {
			line  = 'gl',
			block = 'gb',
		},
		extra = {
			above = nil,
			below = nil,
			eol   = 'gL'
		}
	}
},
{
	-- make text object
	'chrisgrieser/nvim-various-textobjs',
	commit = '674b7c9', -- use multiCommentedLines until update nvim v.10
	keys = {
		-- textobject with above/below and blank
		{'vii', function() require('various-textobjs').indentation('inner', 'inner') end, },
		-- textobject in comment block
		{'vic', function() require('various-textobjs').multiCommentedLines() end, },
	},
	opts = {
		lookForwardSmall = 5,
		lookForwardBig = 15,
		useDefaultKeymaps = false, -- not use suggested keymaps, but it does not work
		disableKeymaps = {},
	},
},
}
-- 'nvim-treesitter/nvim-treesitter-textobjects' : it makes textobject with comment line only, not block
-- 'danymat/neogen' : it is useful when I put description for functions even if cursor is in the function.
-- 					  it takes the cursor to top of the funciton rapidly. but the template is can be maed by luasnip
-- 					  I think it can be replaced by luasnip
