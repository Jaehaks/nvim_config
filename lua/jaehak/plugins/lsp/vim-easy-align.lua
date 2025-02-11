return {
{
	'junegunn/vim-easy-align',
	keys = {
		{'<C-\\>', mode = {'n', 'v'}},
		{'<C-S-\\>', mode = {'n', 'v'}},
	},
	config = function()
		vim.g.easy_align_delimiters = {
			[';'] = {				-- add delimiters ';'
				pattern = ';',
				left_margin = 1,
				right_margin = 1,
				stick_to_left = 0,
			},
			-- alignment rule is identified by a single-character key.  it needs to set ignore_group and \\+
			['c'] = {				-- add delimiters '--', lua comment
				pattern = '--\\+',
				left_margin = 1,
				right_margin = 1,
				stick_to_left = 0,
				ignore_groups = {'!Comment'}
			},
			['%'] = {				-- add delimiters '%', matlab comment
				pattern = '%\\+',
				left_margin = 1,
				right_margin = 1,
				stick_to_left = 0,
				ignore_groups = {'!Comment'}
			},
			[','] = {				-- add delimiters '%', matlab comment
				pattern = ',',
				left_margin = 0,
				right_margin = 1,
				stick_to_left = 0,
			}
		}
		vim.keymap.set({'n', 'x'}, '<C-\\>',   ':EasyAlign ')
		vim.keymap.set({'n', 'x'}, '<C-S-\\>', ':EasyAlign *')
	end
},
}
