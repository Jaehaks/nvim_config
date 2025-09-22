return {
{
	-- buffer manager to edit/move buffer quickly
	-- cons : bmui.save_menu_to_file() make a file in current directory. not nvim-data
	-- 'j-morano/buffer_manager.nvim',
	-- branch = 'main',
	'Jaehaks/bufman.nvim',
	keys = {
		{ '<leader>fb', function () require('bufman').toggle_manager() end , {noremap = true, desc = 'open buffer window'} },
		{ '<M-m>', function() require('bufman').bnext() end, {noremap = true, desc = 'go to next buffer'} },
		{ '<M-n>', function() require('bufman').bprev() end, {noremap = true, desc = 'go to previous buffer'} },
	},
	opts = {
		formatter = {'shortcut', 'bufnr', 'indicator', 'icon', 'filename', 'mindir'},
		keys = {
			toggle_edit = 'e',
			reorder_upper = 'J',
			reorder_lower = 'K',
			update_and_close = 'q',
			close = '<Esc>',
		},
		sort = {
			method = 'stack',
		}
	},
},
}
-- EL-MASTOR/bufferlist.nvim : It has delay whenever I open listed buffer, Why? I have no idea
-- wasabeef/bufferin.nvim : It really good, but some lags are existed and I cannot change j,k key
-- loath-dub/snipe.nvim : it is cool to navigate buffer but it doesn't support deleting visualized buffer
-- 						  or set shorcut key from dictionary only not first letter of file.
-- 						  or reorder buffer list
