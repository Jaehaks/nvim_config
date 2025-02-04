return {
	-- buffer manager to edit/move buffer quickly
	-- cons : bmui.save_menu_to_file() make a file in current directory. not nvim-data
	-- 'j-morano/buffer_manager.nvim',
	-- branch = 'main',
	'Jaehaks/buffer_manager.nvim',
	branch = 'fix/short_file_name_properly',
	dependencies = {
		'nvim-lua/plenary.nvim'
	},
	config = function ()
		local bm = require('buffer_manager')
		local bmui = require('buffer_manager.ui')
		bm.setup({
			select_menu_item_commands = {
				vsplit = {
					key = '<C-v>',
					command = 'vsplit'
				},
				hsplit = {
					key = '<C-x>',
					command = 'split'
				},
				edit = {
					key = '<CR>',
					command = 'edit'
				},
				-- BUG: mapping key doesn't work properly
			},
			-- BUG: short_file_names doesn't work properly
			-- I think it is caused by windows path delimiter '\\', it will be solved if PR(#35) is applied
			short_file_names = true, -- show shorten filename
			short_term_names = true,
			loop_nav = true,
		})

		vim.api.nvim_set_hl(0, 'BufferManagerModified', {fg = '#FF00FF'}) -- set highlight modified and not saved buffers in manager
		-- vim.keymap.set('n', '<M-m>', bmui.nav_next, {noremap = true, desc = 'go to next buffer'})
		-- vim.keymap.set('n', '<M-n>', bmui.nav_prev, {noremap = true, desc = 'go to prev buffer'})
		-- vim.keymap.set('n', '<leader>fb', bmui.toggle_quick_menu, {noremap = true, desc = 'open buffer window'})
	end
}
