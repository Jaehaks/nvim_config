return {
 -- save yank history
	'ptdewey/yankbank-nvim',
	config = function ()
		local yankbank = require('yankbank')
		yankbank.setup({
			max_entries = 10, -- max history
		})
		vim.keymap.set("n", "<leader>y", ":YankBank<CR>", { noremap = true })
	end
}


