local paths = require('jaehak.core.paths')
return {
	'RRethy/vim-illuminate',
	main = 'illuminate', -- vim-illuminate use 'illuminate' as its main folder
	-- event = 'CursorMoved',
	ft = paths.Filetypes.ForIlluminate,
	opts = function()
		vim.api.nvim_set_hl(0, "IlluminatedWordText", {bg = "#45535D"})
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", {bg = "#45535D"})
		vim.api.nvim_set_hl(0, "IlluminatedWrite", {bg = "#45535D"})

		return {
			--providers = {'lsp', 'regex'},
			providers = {'regex'},	-- if using lsp, entire text in '' is highlighted
			delay = 300,
			lcarge_file_curoff = 8000,
			filetypes_denylist = {
				'help',
				'lir',
				'TelescopePrompt',
			},
			min_count_to_highlight = 2,

			-- IlluminatedWordText : no kind information word,   like text  (using 'regex' provider)
			-- IlluminatedWordRead : kind information word,   like variables (using 'lsp' provider)
			-- for gui,  view :h attr-list
			-- gui=NONE : delete underline in highlight
		}
	end,
	config = function(_, opts)
		require('illuminate').configure(opts) -- it doesn't convention, use configure
	end
}
