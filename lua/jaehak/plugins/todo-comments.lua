return {
	'folke/todo-comments.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim'
	},
	config = function()
		local todo = require('todo-comments')
		todo.setup({
			signs = false, -- disable icon
			colors = {
				error   = {"#DC2626" },
				hint    = {"#10A981" },
				info    = {"#2563EB" },
				test    = {"#FF00FF" },
				warning = {"#FABf24" },
				tbd     = {"#7C3AED" },
			},
			keywords = {	-- keywords recognized as todo comments
			FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" , "FAILED" }}, -- test failed, to be continue
			TODO = { icon = " ", color = "hint" , alt = { "WHATFOR", "FOR", "WHAT" }}, -- hint
			CONF = { icon = " ", color = "info",  alt = { "PASSED", "Confirmed" }},  -- code confirm completed
			TEST = { icon = "⏲ ", color = "test",  alt = { "TESTING" }},               -- for testing code
			TBD  = { icon = " ", color = "tbd",   alt = { "LATER" }}, -- to be continue
			-- WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			-- PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			},
			gui_style = {
				fg = "NONE", -- The gui style to use for the fg highlight group.
				bg = "BOLD", -- The gui style to use for the bg highlight group.
			},
			merge_keywords = true,               -- when true, custom keywords will be merged with the defaults
			highlight = {
				multiline = false,               -- disable multine todo comments
				multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
				multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
				before = "fg",                   -- colored before keyword
				keyword = "wide",                -- colored left/right of keyword
				after = "fg",                    -- colored after keyword
				pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
				comments_only = true,            -- uses treesitter to match keywords in comments only
				max_line_len = 5000,             -- ignore lines longer than this
				exclude = {},                    -- list of file types to exclude highlighting
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				pattern = [[\b(KEYWORDS):]], -- ripgrep regex to find keyword todo list
				-- pattern to be todo comment is "-- FIX: blar blar, semicolon(:) must be next to keyword without space"
			},
		})

		vim.keymap.set('n', ']t', todo.jump_next, {desc = 'Next todo comment'})
		vim.keymap.set('n', '[t', todo.jump_prev, {desc = 'Prev todo comment'})
		vim.keymap.set('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', {desc = 'Todo Telescope'})
	end
}
