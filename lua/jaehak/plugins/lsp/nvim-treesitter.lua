return {{
	enabled = true,
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	config = function()
		local configs = require('nvim-treesitter.configs')
		local installs = require('nvim-treesitter.install')
		installs.prefer_git = false
		installs.compilers = {'gcc'}

		configs.setup({
			ensure_installed = { 'lua', 'luadoc', 'luap', 'luau',
								 'matlab',
								 'python',
							 	 'vim', 'vimdoc',
								 'markdown', 'markdown_inline',
								 'diff', 'regex', 'ssh_config'},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = false,
			},
			matchup = {
				enable = true,
			}
		})
	end,
},
}
