return {
	-- 1) powershell (default in windows)
	-- 2) git for windows
	-- 3) tar (default in windows)
	-- 4) 7zip (download)
	-- 5) curl (default in windows)
	-- 6) npm (download)
	'williamboman/mason.nvim',
	lazy = false,  	-- lazy-loading is not recommended
	dependencies = {
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
	},
	config = function()
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local mason_tool = require('mason-tool-installer')

		mason.setup({

		})

		mason_lspconfig.setup({
			ensure_installed = {		-- server automatically install if it is not installed
				'lua_ls',
				'matlab_ls',
				'marksman'
			}
		})

		mason_tool.setup({
			ensure_installed = {
				'lua_ls',
				'matlab_ls',
				'marksman'
			},
			auto_update = true,
		})
	end

}
