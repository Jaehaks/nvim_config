return {
	-- change default shape of vim.ui.select / vim.ui.input
	-- 1) change select box in neogit
	'stevearc/dressing.nvim',
	lazy = false,
	config = function ()
		require('dressing').setup({
			input = {
				enabled = true,
				title_post = 'center',
			},
			select = {
				enabled = true,
				backend = {'telescope', 'builtin'}, 	-- use my telescope ui first
				telescope = require('telescope.themes').get_dropdown({ -- initial mode is insert mode when using vim.ui.select
					initial_mode = 'insert'
				})
			}
		})
	end
}
