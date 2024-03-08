return {
	'echasnovski/mini.comment',
	enabled = false,
	version = '*',
	event = 'VeryLazy',
	config = function()
	    require('mini.comment').setup({
			options = {
				ignore_blank_line = false,
				start_of_line = false, 			-- if true, comment located at SOL
												-- BUG: but when comment out by toggle, the line is indented by 1 char
			},
			mappings = {
				comment = 'gc',			-- for following command, like "gcip"
				comment_line = 'gl',
				comment_visual = 'gl',
				textobject = 'gc', 		-- for preceding command, like "dgc", delete comment region on cursor
			}

		})
	end
}
