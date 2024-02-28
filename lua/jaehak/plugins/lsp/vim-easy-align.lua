return {
	'junegunn/vim-easy-align',
	event = 'VeryLazy',
	config = function()
		vim.g.easy_align_delimiters = {
			[';'] = {				-- add delimiters ';'
				pattern = ';',
				left_margin = 1,
				right_margin = 1,
				stick_to_left = 0,
			}
		}
		vim.keymap.set({'n', 'x'}, '<C-=>', ':EasyAlign ')
		vim.keymap.set({'n', 'x'}, '<C-S-=>', ':EasyAlign *')
	end
}
