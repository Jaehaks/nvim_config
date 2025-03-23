local paths = require('jaehak.core.paths')
return {
{
	-- list up important files (add list to nvim-data/grapple)
	-- Caution!! : file path must not have white space. But it can accept with non-English directory
	'cbochs/grapple.nvim',
	keys = {
		{'<leader>pa', function() require('grapple').toggle() end, desc = 'add/delete this file to grapple list'},
		{'<leader>pf', function() require('grapple').toggle_tags() end, desc = 'open grapple file list'},
	},
	ft = {'dashboard'},
	opts = {
		scope = 'global',
		prune = nil, -- unset prune timer?
		style = 'basename',
		-- telescope extension : it does not support 'basename' style. (grapple use grapple's telescope setting)
	},
	-- grapple.toggle_tags() : show files list that are added
	-- grapple.toggle_loaded() : show directories which include buffer that has tag and is "loaded"
},
{
	'natecraddock/sessions.nvim',
	enabled = false,
	keys = {
		-- keymap for load session
		{'<leader>ps', function ()
			require('sessions').load(paths.session.saved, {autosave = false})
		end, desc = 'load last session'},
	},
	ft = 'dashboard',
	opts = {
		events = {'VimLeavePre'},
		session_filepath = paths.session.saved,
		absolute = true,
	},
	config = function (_, opts)
		local sessions = require('sessions')
		sessions.setup(opts)

		-- Save sessions on vim exit
		local User_augroup = vim.api.nvim_create_augroup('sessions',{clear = true})
		vim.api.nvim_create_autocmd('VimLeavePre', {
			group = User_augroup,
			pattern = '*',
			callback = function ()
				require('sessions').save(paths.session.saved, {autosave = false})
			end
		})
	end
},
{
	'Jaehaks/last-session.nvim',
	version = '*',
	opts = {
		auto_save = true,
		path = paths.last_session.saved,
		ignored_list = {
			ignored_type = {
				'help',
			},
			ignored_dir = {
				'doc\\'
			}
		}
	}
}

}
-- ///////// workspace plugins
-- ahmedkhalf/project.nvim : it change vim.opt.autochdir option to false automatically
-- 							 it has conflict with this plugin
-- cbochs/grapple.nvim : if directory path has white space, fail to find file. it will be opened with blank file => change directory name
-- 						 it cannot trim directory level in grapple window => basename
-- 						 file base, not project (for quick access)
-- LintaoAmons/cd-project.nvim : :CdProjectAdd command add only project_dir_pattern.
-- 								 it can add project manually by :CdProjectManualAdd, but it need to enter the absolute path (complicatedly)
-- 								 or edit json config file to add/del
-- nvim-telescope/telescope-project.nvim : it looks good, editing project list is very powerful
-- 										   README said it create project with cwd, but it has some bug with autochdir option.
-- 										   cannot find cwd properly although :pwd display current file location
-- 										   it make me very confused
-- ThePrimeagen/harpoon : harpoon list scope is only cwd not global.}
-- gnikdroy/projections.nvim : I cannot see any project in telescope extension... I don't know how to use this..
-- coffebar/neovim-project : it needs to write project path in configuration file, not in nvim-data
-- 'otavioschwanck/arrow.nvim' : why doesn't it work?
-- 'natecraddock/workspaces.nvim' : it save cwd as workspace. Opening workspace means that change cd.
-- 								    it will be useful with hooks after load workspace like telescope find_files,
-- 								    now From combination of grapple, telescope and oil, it can be replaced to workspace's behavior
-- 'Rics-Dev/project-explorer.nvim' : how to use? and no docs. default keymapping doesn't work
--


-- ///////// sessions plugins
-- possession.nvim : it support saving session with specific name. it works well,
-- 					 but it cannot autosave current session when neovim is quit
-- 					 It has long load time >150ms
-- neovim-session-manager : I don't know how to work. It works along to current directory.
-- 							save the session with current directory name. It cannot save the session except one file
-- 							It has short load time < 20ms
-- persisted.nvim : it has long load time
-- 					it doesn't work.. it saves session as path and show blank buffer window when I load session
-- folke/persistence.nvim : it works well. autosaving on quit.
-- 						    it has fast load time <20ms.  it supports only saving last session
-- 						    it save the session to file with cwd name
-- 						    it cannot save the session state. only list of buffers
-- natecraddock/sessions.nvim : it is blazingly fast! (<5ms). I don't know what start_autosave() works but
-- 							    auto saving is implemented by autocmd. it save last session
-- 							    I can set the file name. so all session is saved to one file
-- 							    usually I will need the last session
