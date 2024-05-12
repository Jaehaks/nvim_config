return {
	'nvim-pack/nvim-spectre',
	event = 'InsertEnter',
	dependencies = {
		'nvim-lua/plenary.nvim'
	},
	config = function ()
		require('spectre').setup({
			mapping = {
				['run_current_replace'] = {
					map = "y",
					cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
					desc = "replace current line"
				},
				['run_replace_all'] = {
					map = "<C-y>",
					cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
					desc = "replace all"
				},
			}

		})

		-- only current file and word under cursor
		vim.keymap.set('n', '<leader>sf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file" })
		vim.keymap.set('v', '<leader>sw', '<cmd>lua require("spectre").open_visual()<CR>', { desc = "Search visual word" })
	end
}
