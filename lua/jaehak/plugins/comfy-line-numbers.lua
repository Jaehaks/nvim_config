return {
	-- show line number with only left side(1~5) number to convenient manipulate
	'Jaehaks/comfy-line-numbers.nvim',
	event = 'BufReadPost',
	opts = {
		up_key = 'j',
		down_key = 'k',
	}
}
