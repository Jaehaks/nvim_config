return {
	-- show minimap
	'Isrothy/neominimap.nvim',
	version = 'v3.*.*',
	lazy = false,
	init = function ()
		vim.opt.wrap = false       -- default false,

		vim.g.neominimap = {
			auto_enable = false,
			log_path = vim.fn.stdpath('data') .. '\\neominimap.log',
			exclude_filetypes = {
				'help',
				'dashboard',
			},
			exclude_buftypes = {
				'nofile',
				"nowrite",
				"quickfix",
				"terminal",
				"prompt",
			},
			layout = 'float',
			float = {
				minimap_width = 20,       --- @type integer
				max_minimap_height = nil, --- @type integer
				margin = {
					right = 0,            --- @type integer
					top = 0,              --- @type integer
					bottom = 0,           --- @type integer
				},
				z_index = 1,              --- @type integer
				--- @type string | string[] | [string, string][]
				window_border = "single",
			},
			delay = 200, -- delay to update after text changed
			diagnostic = {
				enabled = true,
			},
			git = {
				enabled = true,
				icon = {
					add = '+ ',
					change = '~ ',
					delete = '- ',
				}
			},
			search = {
				enabled = false,
			},
			treesitter = {
				enabled = true,
			},
			mark = {
				enabled = true,
			},
			fold = {
				enabled = true,
			}
		}

		vim.g.neominimap_manual = false
		vim.keymap.set('n', '<leader>n', function ()
			require('neominimap').toggle()
			if require('neominimap.variables').g.enabled then
				vim.g.neominimap_manual = true
			else
				vim.g.neominimap_manual = false
			end
		end, {noremap = true, desc = 'Toggle minimap'})
	end,
}
