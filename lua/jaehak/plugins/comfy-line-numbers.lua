return {
	-- show line number with only left side(1~5) number to convenient manipulate
	'mluders/comfy-line-numbers.nvim',
	event = 'BufReadPost',
	opts = {
		up_key = 'j',
		down_key = 'k',
		hidden_file_types = {
			'dashboard',
			'help',
			'gitcommit',
		}
	}
}
