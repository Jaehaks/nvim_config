return {
	'piersolenski/import.nvim',
	keys = {
		{'<leader>i', function () require('import').pick() end, desc = 'import modules'}
	},
	opts = {
		picker = 'snacks',
		insert_at_top = true,
	}

}
