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
				-- matlab = rainbow_delimiters.strategy['global'],
			},
			priority = {
				[''] = 110,
				lua = 210,
				-- matlab = 310,
			},
			query = {
				[''] = 'rainbow-delimiters',
				query = 'rainbow-delimiters',
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
	enabled = false,
	event = 'VeryLazy',
	config = function ()
		require('match-up').setup({})
		vim.g.loaded_matchit = 1
		vim.matchup_matchparen_enabled = 1
		vim.g.matchup_matchparen_offscreen = {method = 'popup'}
	end
},
{
	'frazrepo/vim-rainbow',
	enabled = false,
	event = 'VeryLazy',
	config = function()

		vim.g.rainbow_active = 1
		vim.cmd([[ let g:rainbow_guifgs = ['#333333', '#555555', 'DarkOrchid3', 'FireBrick'] ]])
		vim.cmd([[ let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta'] ]])
	end
},
{
	'luochen1990/rainbow',
	enabled = false,
	config = function ()
		vim.g.raibow_active = 1
	end
}
}

