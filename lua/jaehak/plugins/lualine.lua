return {
{
	'nvim-lualine/lualine.nvim',
	lazy = false,
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function()
		require('lualine').setup({
			options = {
				disabled_filetypes = {'oil', 'Trouble', 'alpha'},
			},
			sections = {
				lualine_b = {'filesize'},
				lualine_c = {'branch', 'filename', 'diagnostics'},
				lualine_y = {'searchcount', 'selectioncount', 'progress'}
			}
		})
	end
},
}
-- heirline.nvim : it can be more powerful, but lualine has more simple way to configure the same configuration.  
