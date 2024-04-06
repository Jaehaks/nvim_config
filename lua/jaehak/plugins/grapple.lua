return {
{
	-- list up important files (add list to nvim-data/grapple)
	-- Caution!! : file path must not have white space. But it can accept with non-English directory
	'cbochs/grapple.nvim',
	enabled = true,
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'nvim-telescope/telescope.nvim'
	},
	config = function ()
		local grapple = require('grapple')

		grapple.setup({
			scope = 'global',
			prune = nil, -- unset prune timer?
			style = 'basename',
		})
		-- telescope extension : it does not apply 'basename' style.

		vim.keymap.set('n', '<leader>pa', grapple.toggle, {desc = 'add/delete this file to grapple list'})
		vim.keymap.set('n', '<leader>pf', grapple.toggle_tags, {desc = 'open grapple file list'})
	end
	-- grapple.toggle_tags() : show files list that are added
	-- grapple.toggle_loaded() : show directories which include buffer that has tag and is "loaded"
},
}
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
-- ThePrimeagen/harpoon : harpoon list scope is only cwd not global.
