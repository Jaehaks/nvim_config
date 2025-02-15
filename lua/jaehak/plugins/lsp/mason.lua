local paths = require('jaehak.core.paths')
return {
	{
		'williamboman/mason-lspconfig.nvim', -- for connection with nvim-lspconfig
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
		lazy = true,
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
		enabled = true,
		lazy = true,  	-- lazy-loading is not recommended
		opts = {

		}
	}
}
