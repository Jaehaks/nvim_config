return {
	'folke/flash.nvim',
	keys = {
		{'w', function () require('flash').jump() end, desc = 'flash jump' }
	},
	opts = {
		modes = {
			search = {
				enabled = false,
			},
			char = {	-- enhanced f, F, t, T
				enabled = true,
			}
		}
	}
}
