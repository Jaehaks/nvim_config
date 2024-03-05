return {
	'folke/flash.nvim',
	event = 'VeryLazy',
	config = function ()
		local flash = require('flash')
		flash.setup({
			modes = {
				search = {
					enabled = false,
				},
				char = {	-- enhanced f, F, t, T
					enabled = false,
				}
			}
		})
--		vim.keymap.del({'n','x','o'}, 'f')
		vim.keymap.set({'n','x','o'}, 'f', flash.jump, {desc = 'flash jump'})
	end
}
