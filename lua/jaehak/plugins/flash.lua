return {
	'folke/flash.nvim',
	keys = {
		{'w'}
	},
	config = function ()
		local flash = require('flash')
		flash.setup({
			modes = {
				search = {
					enabled = false,
				},
				char = {	-- enhanced f, F, t, T
					enabled = true,
				}
			}
		})
		vim.keymap.set({'n','x','o'}, 'w', flash.jump, {desc = 'flash jump'})
	end
}
