local paths = require('jaehak.core.paths')
return {
{
	-- dashboard is faster a little?
	'nvimdev/dashboard-nvim',
	cond = function()
		return vim.fn.argc() == 0 -- load dashboard when I open nvim using 'nvim' only (no argument)
	end,
	init = function ()
		-- vim.opt_local.modifiable = true
		vim.opt.modifiable = true
	end,
	opts = {
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
					action = function () require('jaehak.core.utils').oldfile_picker() end,
				},
				{
					icon = '',
					desc = 'Folder : Config', desc_hl = 'String',
					key = 'c', key_hl = 'DashboardShortCut',
					action = function ()
						if vim.g.has_win32 then
							require('oil').open_float(require('jaehak.core.paths').nvim.config)
						else
							require('yazi').yazi(nil, require('jaehak.core.paths').nvim.config)
						end
					end,
				},
				{
					icon = '',
					desc = 'Folder : D:\\MATLAB_Project', desc_hl = 'String',
					key = 'd', key_hl = 'DashboardShortCut',
					action = function ()
						if vim.g.has_win32 then
							require('oil').open_float(require('jaehak.core.paths').project.matlab)
						else
							require('yazi').yazi(nil, require('jaehak.core.paths').project.matlab)
						end
					end,
				},
				{
					icon = '',
					desc = 'Folder : Note', desc_hl = 'String',
					key = 'n', key_hl = 'DashboardShortCut',
					action = function () require('oil').open_float(require('jaehak.core.paths').obsidian.personal) end,
				},
				-- {
				-- 	icon = '',
				-- 	desc = 'Bookmark Files', desc_hl = 'String',
				-- 	key = 'p', key_hl = 'DashboardShortCut',
				-- 	action = function () require('grapple').toggle_tags() end,
				-- },
				{
					icon = '',
					desc = 'Last Sessions', desc_hl = 'String',
					key = 's', key_hl = 'DashboardShortCut',
					-- action = function () require('sessions').load(require('jaehak.core.paths').session.saved, {autosave = false}) end,
					action = function () require('last-session').load_session() end,
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
	},
	config = function(_, opts)
		require('dashboard').setup(opts)

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
