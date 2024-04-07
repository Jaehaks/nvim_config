return {
	-- save yank history
	'ptdewey/yankbank-nvim',
	event = 'VeryLazy',
	config = function ()

		local yankbank = require('yankbank')

		yankbank.setup({
			max_entries = 9, -- max history
			sep = "          ",
			keymaps = {
				navigation_next = 'k',
				navigation_prev = 'j',
			},
			num_behavior = 'jump' -- go to the number of list when i enter only number
		})

		vim.keymap.set("n", "<leader>y", ":YankBank<CR>", { noremap = true })
	end

}


