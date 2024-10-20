return {
	'folke/trouble.nvim',
	event = 'LspAttach',
	dependencies = {'nvim-tree/nvim-web-devicons'},
	config = function ()
		local trouble = require('trouble')
		trouble.setup({
			auto_close   = true,
			auto_preview = true, -- move view to the selected item automatically
			focus        = true, -- focus trouble window when opened
			follow       = true, -- start trouble item from current cursorline

			keys = {
				["?"]     = "help",
				q         = "close",
				o         = "jump_close",
				["<esc>"] = "cancel",
				["<cr>"]  = "jump",
				["<c-s>"] = "jump_split",
				["<c-v>"] = "jump_vsplit",
				-- go down to next item (accepts count)
				k         = "next",
				-- go up to prev item (accepts count)
				j         = "prev",
				dd        = "delete",
				d         = { action = "delete", mode = "v" },
				i         = "inspect",
			},
		})
		vim.keymap.set({'n'}, '<leader>xt', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', {desc = 'Toggle Trouble window of current buffer'})
		vim.keymap.set({'n'}, '<leader>xT', '<Cmd>Trouble diagnostics toggle <CR>', {desc = 'Toggle Trouble window of project'})
	end
}
