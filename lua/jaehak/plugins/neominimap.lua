return {
	-- show minimap
	'Isrothy/neominimap.nvim',
	version = 'v3.*.*',
	-- lazy = false,
	lazy = true,
	keys = {
		{'<leader>n'},
	},
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
				enabled = true,
				mode = 'icon',
				icon = '󰱽 ',
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


		-- neominimap toggle
		local neominimap = require('neominimap')

		vim.g.neominimap_manual = false
		vim.keymap.set('n', '<leader>n', function ()
			local winid_list = vim.api.nvim_list_wins()
			local winid_cur = vim.api.nvim_get_current_win()
			local winid_other = winid_list
			for i, v in ipairs(winid_list) do -- get other win id
				if v == winid_cur then
					table.remove(winid_other, i)
				end
			end

			neominimap.toggle()
			if require('neominimap.variables').g.enabled then
				vim.g.neominimap_manual = true
				neominimap.winOff(winid_other) -- turn off neominimap except current window
				neominimap.winOn({winid_cur}) -- turn on neominimap in current window
			else
				vim.g.neominimap_manual = false
			end
		end, {noremap = true, desc = 'Toggle minimap'})

		vim.api.nvim_set_hl(0, "NeominimapSearchIcon", {fg = "#FFFF00" }) -- searched sign color
		vim.api.nvim_set_hl(0, "NeominimapSearchSign", {fg = "#FFFF00" }) -- searched icon color
	end,
}
