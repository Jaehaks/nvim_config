return {
	"FabijanZulj/blame.nvim",
	keys = {
		{'<leader>hm', '<Cmd>BlameToggle window<CR>', desc = 'Git Blame'}
	},
	config = function ()
		require('blame').setup({
			date_format = '%Y-%m-%d',
			format_fn = require('blame.formats.default_formats').date_message,
			blame_options = {
				'-w', -- skip blame which adjust whtie space only
			},
			mappings = {
				commit_info = "i",     -- brief commit information (commit title)
				show_commit = "<CR>",  -- full commit information (commit contents)
				stack_push  = "<TAB>", -- show entire code selected commit in current buffer (go before)
				stack_pop   = "<BS>",  -- restore from stack push
				close       = { "<esc>", "q" },
			}
		})
	end
}
