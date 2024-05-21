return {
	"NeogitOrg/neogit",
	version = 'v0.0.1', -- neovim 0.9.5 compatible
	keys = { -- negit loading time is too long
		{'<leader>go', '<Cmd>Neogit<CR>', desc = 'open neogit default', 'n'}
	},
	dependencies = {
		"nvim-lua/plenary.nvim",         -- required
		"sindrets/diffview.nvim",        -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function ()
		local neogit = require('neogit')
		neogit.setup({
			-- use_default_keymaps = true,
			disable_line_numbers = false,
			kind = 'tab', -- default window of opening neogit
			status = {
				recent_commit_count = 20,
			},
			-- commit_editor = {
			-- 	kind = 'split_above' -- horizontal split
			-- },
			-- popup = {
			-- 	kind = 'split_above'
			-- },
			integrations = {
				telescope = false,
				diffview = true,
				fzf_lua = false,
			}
		})
		-- it is very wiere
		-- test tset it is just test 

		-- vim.keymap.set('n', '<leader>go', neogit.open, {desc = 'open neogit default'})
	end
}
