return {
{
	'altermo/ultimate-autopair.nvim',
	event = {'InsertEnter', 'CmdlineEnter'},
	branch = 'v0.6',
	opts = {
		profile = 'default',
		multiline = false,
		bs = {
			enable = true,
			overjumps = false,	-- disable (*foo) -> *foo
			space = false,		-- disable ( *foo ) -> (*foo)
		},
		fastwarp = {
			enable = false,
		}
	},
},
{
	-- auto highlight to brackets
	'HiPhish/rainbow-delimiters.nvim',
	enabled = false,
	event = 'VeryLazy',
	config = function ()
		-- This module contains a number of default definitions
		local rainbow_delimiters = require('rainbow-delimiters')
		local rainbow_delimiters_setup = require('rainbow-delimiters.setup')

		-- rainbow_delimiters.config
		rainbow_delimiters_setup.setup({
			strategy = {
				[''] = rainbow_delimiters.strategy['global'],
				matlab = rainbow_delimiters.strategy['global'],
			},
			priority = {
				[''] = 110,
				lua = 210,
				matlab = 310,
			},
			query = {
				[''] = 'rainbow-delimiters',
				matlab = 'rainbow-delimiters',
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
{
	'andymass/vim-matchup',
	enabled = true,
	event = 'VeryLazy',
	config = function ()
		require('match-up').setup({})
		vim.g.loaded_matchit = 1
		vim.matchup_matchparen_enabled = 1
		vim.g.matchup_matchparen_offscreen = {method = 'popup'}
	end
}
}

