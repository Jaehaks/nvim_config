return {
	'folke/trouble.nvim',
	lazy = true,
	cmd = 'Trouble',
	opts = {
		auto_close   = true,
		auto_preview = true, -- move view to the selected item automatically
		focus        = true, -- focus trouble window when opened
		follow       = true, -- start trouble item from current cursorline

		keys = {
			["?"]     = "help",
			q         = "close",
			o         = "jump_close",
			["<esc>"] = "cancel",
			["<cr>"]  = "jump",
			["<c-s>"] = "jump_split",
			["<c-v>"] = "jump_vsplit",
			-- go down to next item (accepts count)
			k         = "next",
			-- go up to prev item (accepts count)
			j         = "prev",
			dd        = "delete",
			d         = { action = "delete", mode = "v" },
			i         = "inspect",
		},
	},
}
