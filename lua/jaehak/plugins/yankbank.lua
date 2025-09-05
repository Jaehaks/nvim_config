return {
	-- save yank history
	'ptdewey/yankbank-nvim',
	keys = {
		{'<leader>y', ':YankBank<CR>', noremap = true, desc = 'YankBank list'},
		{'y', mode={'n', 'v'}},
		{'yy', mode={'n', 'v'}},
	},
	opts = {
		max_entries = 9, -- max history
		sep = "          ",
		keymaps = {
			navigation_next = 'k',
			navigation_prev = 'j',
		},
		num_behavior = 'jump' -- go to the number of list when i enter only number
	}
}


