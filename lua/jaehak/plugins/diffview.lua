return {
	'sindrets/diffview.nvim',
	event = 'BufReadPost',
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function ()
		local actions = require('diffview.actions')
		require('diffview').setup({
			keymaps = {
				view = {
					{'n', 'q', actions.close}
				},
				file_panel = {
					{'n', 'j', actions.prev_entry , {silent = true}},
					{'n', 'k', actions.next_entry , {silent = true}},
					{'n', 'q', function()
						actions.close()		-- close panel 
						actions.close()		-- close view
					end, {silent = true}},
				}
			}
		})

		vim.keymap.set('n', '<leader>gd', '<Cmd>DiffviewOpen<CR>', {desc = 'open Diffview of .git with HEAD~1'})

	end
}
