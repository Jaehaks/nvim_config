return {
	'akinsho/bufferline.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons', opt = true
	},
	config = function()
		require('bufferline').setup({
			options = {
				show_buffer_icons = false,				-- disable file icons
				show_buffer_close_icons = false,		-- disable close icons
				show_close_icon = false,
				numbers = function(opts)
					return string.format('%s)',opts.id)	-- but it works
				end,
			},
			highlights = {
				buffer_selected = { fg = '#FF00FF' },
				numbers_selected = { fg = '#FF00FF' },
				buffer_visible = {fg = '#bbbbbb'},
				numbers = {fg = '#bbbbbb'},

			}
		})
	end
}

