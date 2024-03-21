return {
	'L3MON4D3/LuaSnip',
	lazy = true,
	build = vim.fn.has('win32') ~= 0 and 'make install_jsregexp' or nil,
	dependencies = {
		'rafamadriz/friendly-snippets',
		'benfowler/telescope-luasnip.nvim'
	},
	config = function ()
		-- /////// configuration of luasnip //////////////
		local ls = require('luasnip')
		ls.config.setup()

		-- /////// configuration of friendly-snippets //////////////
		require('luasnip.loaders.from_vscode').lazy_load()
		ls.filetype_extend('lua', {'luadoc'})
	end
}
