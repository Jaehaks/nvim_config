local paths = require('jaehak.core.paths')
return {
	{
		'williamboman/mason-lspconfig.nvim', -- for connection with nvim-lspconfig
		-- notice paths of lsp execution file to neovim
		-- install automatically at startup and update of lsp
		enabled = false,
		lazy = true,
		-- event = 'BufReadPre',
		opts = {
			ensure_installed = { -- server automatically install if it is not installed
				'lua_ls',
				'matlab_ls',     -- after matlab_ls install, copy matlab-language-server.cmd to nvim-data/mason/bin manually
				'jsonls',
				-- 'ltex',          -- grammar check with LanguageTool
				'harper_ls',
				-- 'ruff_lsp',
				'basedpyright',
				-- 'pylsp',
			}
		}
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		-- install automatically at startup and update of formatter, lineter others
		enabled = false,
		lazy = true,
		-- cmd = {'Mason'},
		-- event = 'BufReadPre',
		opts = {
			ensure_installed = {
				"stylua",      -- formatter for lua
				"latexindent", -- formatter for tex
				"ruff",        -- linter / formatter for python
			},
			auto_update = false,
		}
	},
	{
		-- 1) powershell (default in windows)
		-- 2) git for windows
		-- 3) tar (default in windows)
		-- 4) 7zip (download)
		-- 5) curl (default in windows)
		-- 6) npm (download)
		'williamboman/mason.nvim',
		-- installation of lsp, formatter, linter, debugger
		cmd = {'Mason'},
		enabled = true,
		lazy = true,  	-- lazy-loading is not recommended
		opts = {

		}
	}
}
