return {
	-- ultimate-autopair.nvim  : it is too bulky and slow
	-- m4xshen/autoclose.nvim : more simple, but it cannot ignore like the "'" in "'don't" 
	-- 							and it change some keymaps in settings automatically
{
	-- more simple and smart / but it cannot support filetype
	'echasnovski/mini.pairs',
	version = false,
	config = function ()
		require('mini.pairs').setup({
			modes = { insert = true, command = true, terminal = true },

			mappings = {
				['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
				['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
				['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
				['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },

				[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
				[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
				['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
				['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

				['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
				["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
				['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
			},
		})
	end
},
{
	-- auto highlight to brackets
	-- if you use treesitter highlight, must use the rainbow plugins that uses treesitter grammer, not regex
	-- I'll make matlab query somedays
	'HiPhish/rainbow-delimiters.nvim',
	enabled = true,
	lazy = true, -- from nvim-treesitter
	config = function ()
		-- This module contains a number of default definitions
		local rainbow_delimiters = require('rainbow-delimiters')
		local rainbow_delimiters_setup = require('rainbow-delimiters.setup')

		-- rainbow_delimiters.config
		rainbow_delimiters_setup.setup({
			strategy = {
				[''] = function(bufnr)
					local lc = vim.api.nvim_buf_line_count(bufnr)
					if lc > 5000 then
						return nil -- although it return nil, delimiters make slow read performance 
					end
					return rainbow_delimiters.strategy['global']
				end,
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
{
	-- add endwise, i think it would be useful when use language which does not support snippet
	'RRethy/nvim-treesitter-endwise',
	lazy = true, -- from nvim-treesitter 
	config = function ()
	end
},
-- tpope/vim-endwise : it doesn't work
}

