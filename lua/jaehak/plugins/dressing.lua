return {
	-- change default shape of vim.ui.select / vim.ui.input
	-- 1) change select box in neogit
	'stevearc/dressing.nvim',
	event = 'BufReadPre',
	opts = {
		input = {
			enabled = true,
			title_post = 'center',
		},
		select = {
			enabled = true,
			backend = {'telescope', 'builtin'}, 	-- use my telescope ui first
		}
	}
}
