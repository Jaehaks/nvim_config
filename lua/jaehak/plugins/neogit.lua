return {
{
	"NeogitOrg/neogit",
	keys = { -- negit loading time is too long
		{'<leader>go', '<Cmd>Neogit<CR>', desc = 'open neogit default', 'n'}
	},
	dependencies = {
		"nvim-lua/plenary.nvim",         -- required
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
	-- install libgit2 : choco install libgit2
	-- required : add 'rocks = {enabled = false}' to disable lazy.nvim's luarocks support
	-- 			  to lazy.nvim's setting. because fugit2 can be builded by lua>5.1
	'SuperBo/fugit2.nvim',
	enabled = false,
	opts = {
		libgit2_path = vim.fn.expand('$ChocolateyInstall\\lib\\libgit2\\tools\\libgit2.dll'),
		width = 100,
		min_width = 50,
		content_width = 60,
		max_width = "80%",
		height = "60%",
		external_diffview = false,
		blame_priority = 1,
		blame_info_height = 10,
		blame_info_width = 60,
	},
	dependencies = {
		'MunifTanjim/nui.nvim',
		'nvim-tree/nvim-web-devicons',
		'nvim-lua/plenary.nvim',
		{
			'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
			dependencies = { 'stevearc/dressing.nvim' }
		},
	},
	-- config = function (_, opts)
	-- 	local fugit2 = require('fugit2')
	-- 	fugit2.setup(opts)
	-- end,
	-- cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
	-- keys = {
	-- 	{'<leader>go', '<Cmd>Fugit2<CR>', desc = 'open fuigit2 default', 'n'}
	-- },
},
-- SuperBo/fugit2.nvim : very fast and light. but it cannot change default keymaps. so I cannot commit
}
