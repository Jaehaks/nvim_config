local paths = require('jaehak.core.paths')

return {
{
	'nvim-treesitter/nvim-treesitter',
	-- enabled = false,
	lazy = true, -- by telescope
	dependencies = {
		'HiPhish/rainbow-delimiters.nvim',
		'RRethy/nvim-treesitter-endwise', -- it requires neovim under v0.11
	},
	build = ':TSUpdate',
	init= function ()
		vim.opt.rtp:prepend(paths.nvim.treesitter_queries)
		vim.opt.rtp:prepend(paths.nvim.luarocks)
	end,
	config = function()
		local configs = require('nvim-treesitter.configs')
		local installs = require('nvim-treesitter.install')
		-- local TShighlight = require('nvim-treesitter.highlight')

		installs.prefer_git = false -- sometimes curl has an error (60), it is solved after I execute nvim-qt in terminal
		installs.compilers = {'gcc'}

		configs.setup({
			-- :TSInstall does not work, but :TSInstallSync works
			ensure_installed = { 'lua', 'luadoc', 'luap', 'luau',
								 'c',
								 'matlab',
								 'python',
								 'vim', 'vimdoc',
								 'markdown', 'markdown_inline',
								 'html', 'json', 'toml',
								 'diff', 'regex', 'ssh_config', 'powershell',
							   	 'latex' -- for latex, tree-sitter-cli must be installed first, (scoop install main/tree-sitter)
			},
			highlight = {
				enable = true,  -- if highlight, cannot use rainbow bracket.
								-- because treesitter managed highlighting bracket also.
				-- treesitter highlight decrease overall performance.
				-- highlight off if the file has too long lines, like help file lspconfig-server-configuration.md
				-- it means that conceal of treesitter is disabled also.
				disable = function (lang, bufnr)
					if lang == "latex" then
						return vim.bo.filetype ~= 'markdown'
					end
					return vim.api.nvim_buf_line_count(bufnr) > 5000
				end,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = false,
			},
			endwise = {			-- nvim-treesitter-endwise
				enable = true
			},
		})

		-- custom_captures for latex not work
		-- vim.api.nvim_set_hl(0, "@markup.math.latex" , { link = 'NightflyYello'}) -- it has bug. but is the best...
	end,
},
{
	-- rendering help using vimdoc treesitter
	"OXY2DEV/helpview.nvim",
	ft = 'help',
	-- lazy = false, -- Recommended
	dependencies = {
		"nvim-treesitter/nvim-treesitter"
	}
}
}
