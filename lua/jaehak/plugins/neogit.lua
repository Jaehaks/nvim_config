return {
	"NeogitOrg/neogit",
	-- version = 'v0.0.1', -- neovim 0.9.5 compatible
	keys = { -- negit loading time is too long
		{'<leader>go', '<Cmd>Neogit<CR>', desc = 'open neogit default', 'n'}
	},
	dependencies = {
		"nvim-lua/plenary.nvim",         -- required
		"sindrets/diffview.nvim",        -- optional - Diff integration
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
			commit_editor = {
				kind = 'split', -- horizontal split below
				show_staged_diff = false,	-- disable diff in commit message 
			},
			console_timeout = 10000,	-- neogit loading slow.
			integrations = {
				telescope = false,
				diffview = true,
				fzf_lua = false,
			},
			mappings = {
				status = {
					['k'] = 'MoveDown',
					['j'] = 'MoveUp',
				}
			},
		})

		-- vim.keymap.set('n', '<leader>go', neogit.open, {desc = 'open neogit default'})
	end
}
