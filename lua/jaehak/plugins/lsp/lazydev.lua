return{
	-- replacement of neodev, for neovim config
	-- but it doesn't supports highlights for vim global variable
	'folke/lazydev.nvim',
	enabled = true,
	ft = 'lua',
	opts = {
		library = {
			-- default : vim global variable's auto completion excepts vim.uv
			{ path = '${3rd}\\luv\\library', words = {'vim%.uv'} }, -- for vim.uv auto completion
			-- `Snacks` library useful when I configure this plugin, it can check undefined variable
		},
		-- -- load lazydev always even though there are .luarc.json
		-- enabled = function (root_dir)
		-- 	return vim.bo.filetype == 'lua'
		-- end
	}
}
