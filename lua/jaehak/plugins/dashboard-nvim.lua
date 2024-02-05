return {
	'nvimdev/dashboard-nvim',
	enabled = false,
	event = 'VimEnter',
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function()
		require('dashboard').setup{
			theme = 'hyper',
			shortcut_type = 'number',
			config = {
				packages = { enable = true }, -- show how many plugins neovim loaded
			}
		}
	end,
}
