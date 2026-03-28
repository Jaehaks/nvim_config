return {
{
	"NeogitOrg/neogit",
	keys = { -- negit loading time is too long
		{'<leader>gO', '<Cmd>Neogit<CR>', desc = 'open neogit default', mode = 'n'}
	},
	dependencies = {
		"sindrets/diffview.nvim",        -- optional - Diff integration
	},
	opts = {
		-- use_default_keymaps = true,
		disable_insert_on_commit      = false,
		commit_date_format            = "%Y-%m-%d %H:%M",
		log_date_format               = "%Y-%m-%d %H:%M",
		process_spinner				  = false, -- show message when git command is running
		disable_line_numbers          = false,
		disable_relative_line_numbers = false,
		kind = 'tab', -- default window of opening neogit
		status = {
			recent_commit_count = 20,
		},
		commit_editor = {
			kind = 'split', -- horizontal split below
			show_staged_diff = false,	-- disable diff in commit message
		},
		console_timeout = 10000,	-- neogit loading slow.
		auto_show_console = false,
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

	}
},
{
	'Jaehaks/gitui.nvim',
	keys = {
		{'<leader>go', function () require('gitui').open() end, desc = 'Open gitui'}
	},
	opts = {

	},
}
-- SuperBo/fugit2.nvim : very fast and light. but it cannot change default keymaps. so I cannot commit
}
