return {
	'akinsho/bufferline.nvim',
	dependencies = {
		'kyazdani42/nvim-web-devicons', opt = true
	},
	config = function()
		require('bufferline').setup({
			options = {
				show_buffer_close_icons = false,
				show_close_icon = false,
			}
		})
	end
}

