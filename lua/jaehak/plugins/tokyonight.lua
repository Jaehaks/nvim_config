return{
	'folke/tokyonight.nvim',
	lazy=false,
	priority=1000,	-- make sure to load first
	opts={},
	config = function() 
		-- colorscheme default setting
		require('tokyonight').setup()
		
		-- colorscheme addtional settings
		require('tokyonight').setup({
			transparent = false,
			style = 'night',
			styles = {
				comments = {fg = '#00FFFF', bold = true, italic = false},	-- if italic on, font is clipped
			},
		})
		vim.cmd[[colorscheme tokyonight]]	-- it must be called after configuration
	end
}
