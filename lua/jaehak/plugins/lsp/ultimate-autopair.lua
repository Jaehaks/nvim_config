return {
{
	'altermo/ultimate-autopair.nvim',
	event = {'InsertEnter', 'CmdlineEnter'},
	branch = 'v0.6',
	opts = {},
},
{
	-- auto highlight to brackets
	'HiPhish/rainbow-delimiters.nvim',
	event = 'VeryLazy',
	config = function ()
		-- This module contains a number of default definitions
		local rainbow_delimiters = require('rainbow-delimiters')

		-- rainbow_delimiters.config
		vim.g.rainbow_delimiters = {
			strategy = {
				[''] = rainbow_delimiters.strategy['global'],
				vim = rainbow_delimiters.strategy['local'],
			},
			query = {
				[''] = 'rainbow-delimiters',
				lua = 'rainbow-blocks',
			},
			priority = {
				[''] = 110,
				lua = 210,
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
		}
	end
}
}

