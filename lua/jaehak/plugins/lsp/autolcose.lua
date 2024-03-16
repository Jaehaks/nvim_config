return {
{
	-- ultimate-autopair.nvim  : it is too bulky and slow
	-- autoclose.nvim more simple
	'm4xshen/autoclose.nvim',
	enabled = true,
	event = 'VeryLazy',
	opts = {
		keys = {
			["<"] = { escape = false, close = true, pair = "<>" },
			["("] = { escape = false, close = true, pair = "()" },
			["["] = { escape = false, close = true, pair = "[]" },
			["{"] = { escape = false, close = true, pair = "{}" },

			[">"] = { escape = true, close = false, pair = "<>" },
			[")"] = { escape = true, close = false, pair = "()" },
			["]"] = { escape = true, close = false, pair = "[]" },
			["}"] = { escape = true, close = false, pair = "{}" },

			['"'] = { escape = true, close = true, pair = '""' },
			["'"] = { escape = true, close = true, pair = "''" },
			["`"] = { escape = true, close = true, pair = "``" },
		},
		options = {
			disabled_filetypes = { "" },
			disable_when_touch = true,			-- autopair is diabled in front of word(\w)
			touch_regex = "[%w(%[{#]",
			pair_spaces = true,
			auto_indent = true,
			disable_command_mode = false,
		},
	},
	config = function(_,opts)
		local autoclose = require('autoclose')
		autoclose.setup(opts)

		-- Although i don't know why it does,   in the middle of setup, <C-h> keymaps in {'i', 'c'} are disabled,
		-- so i have to remap these again
		vim.keymap.set({'i','c'}, '<C-h>', '<Left>', {noremap = true})

	end
},
{
	-- auto highlight to brackets
	-- if you use treesitter highlight, must use the rainbow plugins that uses treesitter grammer, not regex
	-- I'll make matlab query somedays
	'HiPhish/rainbow-delimiters.nvim',
	enabled = true,
	event = 'VeryLazy',
	config = function ()
		-- This module contains a number of default definitions
		local rainbow_delimiters = require('rainbow-delimiters')
		local rainbow_delimiters_setup = require('rainbow-delimiters.setup')

		-- rainbow_delimiters.config
		rainbow_delimiters_setup.setup({
			strategy = {
				[''] = rainbow_delimiters.strategy['global'],
			},
			priority = {
				[''] = 110,
				lua = 210,
			},
			query = {
				[''] = 'rainbow-delimiters',
				-- matlab query for delimiters is added. confirmed it works
				-- copy directory "nvim/queries/rainbow-delimiters.nvim/matlab"  to "nvim-data/lazy/rainbow-delimiters.nvim/queries"
			},
			highlight = {
				'RainbowDelimiterRed',
				'RainbowDelimiterYellow',
				'RainbowDelimiterBlue',
				'RainbowDelimiterOrange',
				'RainbowDelimiterGreen',
				'RainbowDelimiterViolet',
				'RainbowDelimiterCyan',
			},
		})
	end
},
}

