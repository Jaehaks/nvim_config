return {
	"shahshlok/vim-coach.nvim",
	dependencies = {
		"folke/snacks.nvim",
	},
	keys = {
		{ "<F1>", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
	},
	opts = {
		window = {
			border = "rounded",
			title_pos = "center",
		},
		keymaps = {
			copy_keymap = "<C-y>",
			close = "<Esc>",
		},
	},

}
