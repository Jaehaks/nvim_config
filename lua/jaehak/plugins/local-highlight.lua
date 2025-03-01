local paths = require('jaehak.core.paths')
return {
	'tzachar/local-highlight.nvim',
	ft = paths.Filetypes.ForIlluminate,
	opts = {
		disable_file_types = {'help'},
		min_match_len = 2,
		highlight_single_match = false,
		animate = {
			enabled = false,
		},
	}
}
-- RRethy/vim-illuminate : it is useful to highlight word under the cursor before using local-highlight.nvim
-- 						   local-highlight.nvim has faster loading time twice over it.
