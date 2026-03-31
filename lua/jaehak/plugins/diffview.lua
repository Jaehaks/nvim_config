return {
{
	'sindrets/diffview.nvim',
	keys = {
		{'<leader>gd', '<Cmd>DiffviewOpen<CR>', desc = 'open Diffview of .git with HEAD~1'}
	},
	opts = function ()
		local actions = require('diffview.actions')
		return {
			view = {
				default = {
					layout = 'diff2_vertical',
				}
			},
			keymaps = {
				view = {
					{'n', 'q', actions.close}
				},
				file_panel = {
					{'n', 'j', actions.prev_entry , {silent = true}},
					{'n', 'k', actions.next_entry , {silent = true}},
					{'n', 'q', function()
						actions.close()		-- close panel
						actions.close()		-- close view
					end, {silent = true}},
				}
			}
		}
	end,
},
{
	"martindur/zdiff.nvim",
	cmd = "Zdiff",
	keys = {
		{ "<leader>zd", function () require('zdiff').open() end, desc = "Zdiff (vs HEAD)" },
	},
	opts = {
		default_expanded = false, -- Whether files are expanded by default
		default_branch = "main",  -- Default branch for toggle_mode (m key)
		keymaps = {               -- Keymap bindings (defaults)
			goto_file = "<CR>",   -- open file
			toggle = "<Tab>",     -- toggle fold
			close = "q",
			refresh = "R",
			toggle_mode = "m",    -- toggle mode (vs HEAD) to (vs main)
			help = "?",
			yank_ref = "gy",
		},
		icons = {                 -- Icons for UI elements
			collapsed = ">",
			expanded = "v",
			added = "+",          -- hunk added
			deleted = "-",        -- hunk deleted
			modified = "M",       -- file title
		},
		syntax = {
			mode = "projection",  -- context strategy
			max_lines = 10000,    -- Skip projection when either old/new source exceeds this many lines. 0 means unlimited
		},
	},
	config = function (_, opts)
		-- change highlights
		local highlights = {
			DiffAdd    = { bg = "#2a4d4d"},
			DiffDelete = { bg = "#5f243a"},
		}
		for group, settings in pairs(highlights) do
			vim.api.nvim_set_hl(0, group, settings)
		end

		require('zdiff').setup(opts)
	end
}
}

-- zdiff.nvim : It shows git diff without splitting window, It would be nice.
-- 				But It doesn't support showing git diff staged/unstaged separately yet
