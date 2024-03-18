return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",         -- required
		"sindrets/diffview.nvim",        -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function ()
		local neogit = require('neogit')
		neogit.setup({
			disable_line_numbers = false,
			kind = 'tab', -- default window of opening neogit
			integrations = {
				telescope = true,
				diffview = true,
				fzf_lua = false,
			}
		})

		vim.keymap.set('n', '<leader>go', neogit.open, {desc = 'open neogit default'})
		
	end
}
