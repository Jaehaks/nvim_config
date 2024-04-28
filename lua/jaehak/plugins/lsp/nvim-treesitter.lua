return {
{
	enabled = true,
	'nvim-treesitter/nvim-treesitter',
	-- enabled = false,
	lazy = true, -- by telescope
	dependencies = {
		'HiPhish/rainbow-delimiters.nvim',
		'RRethy/nvim-treesitter-endwise',
	},
	build = ':TSUpdate',
	config = function()
		local configs = require('nvim-treesitter.configs')
		local installs = require('nvim-treesitter.install')
		local TShighlight = require('nvim-treesitter.highlight')

		installs.prefer_git = false
		installs.compilers = {'gcc'}

		configs.setup({
			-- :TSInstall does not work, but :TSInstallSync works
			ensure_installed = { 'lua', 'luadoc', 'luap', 'luau',
								 'matlab',
								 'python',
							 	 'vim', 'vimdoc',
								 'markdown', 'markdown_inline', 'html', 'json',
								 'diff', 'regex', 'ssh_config',
							   	 'latex' -- for latex, tree-sitter-cli must be installed first, (scoop install main/tree-sitter)
			},
			highlight = {
				enable = true,  -- if highlight, cannot use rainbow bracket. 
								-- because treesitter managed highlighting bracket also. 
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = false,
			},
			endwise = {			-- nvim-treesitter-endwise
				enable = true
			},
			textobjects = { -- nvim-treesitter-textobjects
				select = {
					enable = true,
					lookahead = true, -- if enter keymap, go to cursor the next treesitter textobject
					keymaps ={
						['ic'] = {query = '@comment.outer', desc = 'select inner part of comment region'}
					},
					selection_modes = {

					},
					include_surrounding_whitespace = false, -- text object is extended to include preceding white space
					-- if true, unnecessary white space is included, 
				}
			}
		})

		-- custom_captures not work
		vim.api.nvim_set_hl(0, "@markup.math.latex" , { link = 'NightflyYello'}) -- it has bug. but is the best...
	end,
},
{
	-- add endwise, i think it would be useful when use language which does not support snippet
	'RRethy/nvim-treesitter-endwise',
	dependencies = {
		'nvim-treesitter/nvim-treesitter'
	},
	config = function ()
	end
},
}
-- tpope/vim-endwise : it doesn't work
