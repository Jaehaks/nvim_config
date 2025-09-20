return {
{
	-- buffer manager to edit/move buffer quickly
	-- cons : bmui.save_menu_to_file() make a file in current directory. not nvim-data
	-- 'j-morano/buffer_manager.nvim',
	-- branch = 'main',
	'Jaehaks/bufman.nvim',
	enabled = true,
	opts = {

	},
	config = function (_, opts)
		local bm = require('bufman')
		bm.setup(opts)
		vim.keymap.set('n', '<leader>fb', bm.toggle_shortcut, {noremap = true, desc = 'open buffer window'})
		vim.keymap.set('n', '<M-m>', bm.bnext, {noremap = true, desc = 'go to next buffer'})
		vim.keymap.set('n', '<M-n>', bm.bprev, {noremap = true, desc = 'go to previous buffer'})
	end
},
}
-- EL-MASTOR/bufferlist.nvim : It has delay whenever I open listed buffer, Why? I have no idea
-- wasabeef/bufferin.nvim : It really good, but some lags are existed and I cannot change j,k key
-- loath-dub/snipe.nvim : it is cool to navigate buffer but it doesn't support deleting visualized buffer
-- 						  or set shorcut key from dictionary only not first letter of file.
-- 						  or reorder buffer list
