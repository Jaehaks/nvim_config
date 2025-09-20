return {
	{
		-- 1) powershell (default in windows)
		-- 2) git for windows
		-- 3) tar (default in windows)
		-- 4) 7zip (download)
		-- 5) curl (default in windows)
		-- 6) npm (download)
		-- installation of lsp, formatter, linter, debugger
		-- 'williamboman/mason.nvim',
		'mason-org/mason.nvim',
		version = '*', -- choose recent stable release version
		cmd = {'Mason'},
		enabled = true,
		lazy = true,  	-- lazy-loading is not recommended
		opts = {
			-- #### installed packages #########

			-- basedpyright
			-- json-lsp
			-- latexindent
			-- lua-language-server
			-- matlab-language-server
			-- pyrefly
			-- ruff
			-- stylua
			-- texlab
			-- vim-language-server
		}
	}
}
