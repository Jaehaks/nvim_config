return {
	-- show minimap
	'Isrothy/neominimap.nvim',
	version = 'v3.*.*',
	lazy = false,
	init = function ()
		vim.opt.wrap = false       -- default false,
		vim.opt.sidescrolloff = 36 -- default 0

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

		vim.keymap.set('n', '<leader>mi', '<Cmd>Neominimap toggle<CR>', {noremap = true, desc = 'Toggle minimap for current window'})
	end,
}
