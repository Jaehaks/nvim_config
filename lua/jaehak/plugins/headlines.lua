return {
	'lukas-reineke/headlines.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter'
	},
	event = {'VeryLazy'},
	config = function ()
		require('headlines').setup({
			markdown = {
				bullets = {}, 		-- disable headline bullet marks
				-- headline_highlights = {'Headline', 'Headline1', 'Headline2', 'Headline3'}
			},
		})

		-- vim.cmd.highlight('Headline1 guibg=#1e2718')
		-- vim.cmd.highlight('Headline2 guibg=#21262d')
		-- vim.cmd.highlight('CodeBlock guibg=#1c1c1c')
		-- vim.cmd.highlight('Dash guibg=#D19A66 gui=bold')
	end
}
