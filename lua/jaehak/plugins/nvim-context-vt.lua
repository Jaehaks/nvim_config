local paths = require('jaehak.core.paths')
return {
	-- cannot recognize like "local foo = function()", but well work  and customize
	'andersevenrud/nvim_context_vt',
	ft = paths.Filetypes.ForCode,
	config = function ()
		require('nvim_context_vt').setup({
			prefix = '    [⌧⌦]',
			highlight = 'NightflyPurple',

		})
	end
}
--	'briangwaltney/paren-hint.nvim',	-->>> it needs to move cursor on bracket, not cursor line
--	'code-biscuits/nvim-biscuits',		-->>> sometimes it dose not exact
