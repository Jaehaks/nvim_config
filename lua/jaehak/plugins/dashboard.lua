return {
{
	-- dashboard is faster a little?
	'nvimdev/dashboard-nvim',
	-- enabled = false,
	event = 'VimEnter',
	init = function ()
		-- vim.opt_local.modifiable = true
		vim.opt.modifiable = true
	end,
	dependencies = { {'nvim-tree/nvim-web-devicons'}},
	config = function()
		require('dashboard').setup {
			theme = 'doom',
			hide = {
				statusline = true,
				tabline = true,
				winbar = true
			},
			config = { -- doom configuration
				center = {
					{
						icon = '',
						desc = 'New File', desc_hl = 'String',
						key = 'e', key_hl = 'DashboardShortCut',
						action = 'ene',
					},
					{
						icon = '',
						desc = 'Recent Files', desc_hl = 'String',
						key = 'r', key_hl = 'DashboardShortCut',
						action = 'Telescope oldfiles',
					},
					{
						icon = '',
						desc = 'Folder : Config', desc_hl = 'String',
						key = 'c', key_hl = 'DashboardShortCut',
						action = [[lua require("oil").open_float(vim.fn.stdpath("config") .. "/lua/jaehak/plugins")]],
					},
					{
						icon = '',
						desc = 'Folder : D:\\MATLAB_Project', desc_hl = 'String',
						key = 'd', key_hl = 'DashboardShortCut',
						action = [[lua require("oil").open_float("D:\\MATLAB_Project")]],
					},
					{
						icon = '',
						desc = 'Bookmark Files', desc_hl = 'String',
						key = 'p', key_hl = 'DashboardShortCut',
						action = [[lua require("grapple").toggle_tags()]],
					},
					{
						icon = '',
						desc = 'Last Sessions', desc_hl = 'String',
						key = 's', key_hl = 'DashboardShortCut',
						action = [[lua require("sessions").load(vim.fn.stdpath('data') .. '\\sessions\\session_saved.txt', {autosave = false})]],
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = stats.startuptime
					local days = {
						'Sunday',
						'Monday',
						'Tuesday',
						'Wednesday',
						'Thursday',
						'Friday',
						'Saturday',
					}
					return {
						'Today : ' .. os.date('%Y-%m-%d %H:%M, ') .. days[tonumber(os.date('%w')+1)],
						'Startup Time : ' .. ms .. 'ms',
						'Plugins : ' .. stats.loaded .. ' loaded / ' .. stats.count .. ' installed'
					}
				end,
			}
		}

		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "DashboardLoaded",
				callback = function()
					require("lazy").show()
				end,
			})
		end
	end,
}
}

-- alpha-nvim : It is very good plugin. I think dashboard's footer is more convenient and faster
-- 				dashboard has more example to implement, but 
