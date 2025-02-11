return {
	{
		'williamboman/mason-lspconfig.nvim', -- for connection with nvim-lspconfig
		lazy = true
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		lazy = true,
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
		-- lazy = false,  	-- lazy-loading is not recommended
		event = 'BufReadPre',  	-- lazy-loading is not recommended
		config = function()
			local mason = require('mason')
			local mason_lspconfig = require('mason-lspconfig')
			local mason_tool = require('mason-tool-installer')

			mason.setup({

			})

			mason_lspconfig.setup({
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
			})

			mason_tool.setup({
				ensure_installed = {
					"lua_ls",
					"matlab_ls",
					"jsonls",
					-- "ltex",
					'harper_ls',
					-- "ruff_lsp",    -- use ruff as linter without nvim-lint for python
					"basedpyright", 	   -- python lsp from Microsoft, completion variables

					"stylua",      -- formatter for lua
					"latexindent", -- formatter for tex
					"ruff",        -- linter / formatter for python
				},
				auto_update = false,
			})
		end
	}
}
