return {
	-- project manager explorer
	"ahmedkhalf/project.nvim",
	enabled = false,
	dependencies = {
		'nvim-telescope/telescope.nvim',
	},
	config = function()
		require("project_nvim").setup {
			manual_mode = true, 	-- to set project root, execute :ProjectRoot
			show_hidden = false,
			silent_chdir = false,
			datapath = vim.fn.stdpath('data'),
		}
		vim.keymap.set('n', '<leader>pa', '<Cmd>ProjectRoot<CR>', {desc = 'set project root'})
	end
}
-- ahmedkhalf/project.nvim : it change vim.opt.autochdir option to  false automatically
