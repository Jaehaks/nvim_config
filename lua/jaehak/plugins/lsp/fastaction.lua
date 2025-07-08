return {
	'Chaitanyabsprip/fastaction.nvim',
	keys = {
		{'ga', function () require('fastaction').code_action() end, mode = {'n', 'x'}, desc = 'Display Code action', buffer = true}
	},
	opts = {
	},
}
