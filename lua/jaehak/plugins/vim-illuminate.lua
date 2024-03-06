return {
	'RRethy/vim-illuminate',
	event = 'VeryLazy',
	config = function()

		-- plugin configuration
		local illuminate = require('illuminate')
		illuminate.configure({
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

		})
		-- IlluminatedWordText : no kind information word,   like text  (using 'regex' provider)
		-- IlluminatedWordRead : kind information word,   like variables (using 'lsp' provider)
		-- for gui,  view :h attr-list
		-- gui=NONE : delete underline in highlight
		vim.cmd([[hi IlluminatedWordText guibg=#45535D gui=NONE]])
		vim.cmd([[hi IlluminatedWordRead guibg=#45535D gui=NONE]])
		vim.cmd([[hi IlluminatedWrite 	 guibg=#45535D gui=NONE]])

	end
}
