return {
	'kevinhwang91/nvim-hlslens',
	config = function ()
		local hlslens = require('hlslens')
		hlslens.setup({

			calm_down = true, -- when the cursor is out of range of matched instance, clear highlight
			nearest_only = true, -- add lens only current matched instance
		})

		local kopts = {noremap = true, silent = true}

		vim.api.nvim_set_keymap('n', 'n',
		[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', 'N',
		[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', '*', [[*N<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
	end
}
