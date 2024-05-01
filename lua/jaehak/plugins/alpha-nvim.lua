return {
{
	'goolord/alpha-nvim',
	enabled = false,
	event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
		local alpha = require('alpha')
		local dashboard = require('alpha.themes.dashboard')

		dashboard.section.buttons.val = {
			dashboard.button('e', '1 - New file'                   , ':ene<CR>'),
			dashboard.button('r', '2 - Recent Files'               , '<Cmd>Telescope oldfiles<CR><Esc>'),
			dashboard.button('c', '3 - Folder : Config'            , [[<Cmd>lua require("oil").open_float(vim.fn.stdpath("config") .. "/lua/jaehak/plugins")<CR>]]), -- open config folder
			dashboard.button('d', '4 - Folder : D:\\MATLAB_Project', [[<Cmd>lua require("oil").open_float("D:\\MATLAB_Project")<CR>]]),                              -- open MATLAB Project
			dashboard.button('p', '5 - Bookmarks'                  , [[<Cmd>lua require("grapple").toggle_tags()<CR>]]),                             -- open project list
		}
        alpha.setup(dashboard.config)	-- setting applied 

		-- key mapping 
		vim.keymap.set('n', '<leader>a', '<Cmd>Alpha<CR>', {noremap = true})
    end
},
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
						desc = 'Bookmarks', desc_hl = 'String',
						key = 'p', key_hl = 'DashboardShortCut',
						action = [[lua require("grapple").toggle_tags()]],
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = stats.startuptime
					local days = {
						'Monday',
						'Tuesday',
						'Wednesday',
						'Thursday',
						'Friday',
						'Saturday',
						'Sunday',
					}
					return {
						'Today : ' .. os.date('%Y-%m-%d %H:%M, ') .. days[tonumber(os.date('%w'))],
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

