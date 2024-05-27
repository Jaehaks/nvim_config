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
	-- if you use treesitter highlight, must use the rainbow plugins that use treesitter grammar, not regex
	-- I'll make matlab query some days
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
				-- matlab query for delimiters is added. Confirmed it works
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

		-- if there is not matlab query directory, make it
		local source_dir = vim.fn.stdpath('config') .. '/queries/rainbow-delimiters.nvim/matlab/'
		local dest_dir = vim.fn.stdpath('data') .. '/lazy/rainbow-delimiters.nvim/queries/matlab/'
		if vim.g.has_win32 == 1 then
			source_dir = source_dir:gsub('/', '\\')
			dest_dir = dest_dir:gsub('/', '\\')
		end
		vim.uv.fs_scandir(dest_dir , function (err, userdata)
				if err then
					vim.uv.fs_mkdir(dest_dir, 777) -- make directory 'matlab'
					vim.uv.fs_copyfile(source_dir .. 'rainbow-delimiters.scm', dest_dir .. 'rainbow-delimiters.scm')
				end
		end)


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
{
	-- show matchparen of current region
	"utilyre/sentiment.nvim",
	version = "*",
	event = "VeryLazy", -- keep for lazy loading
	opts = {
		pairs = {
			{ '(', ')' },
			{ '{', '}' },
			{ '[', ']' },
			{ '<', '>' },
		}
	},
	init = function()
		vim.g.loaded_matchparen = 1
	end,
}
}

