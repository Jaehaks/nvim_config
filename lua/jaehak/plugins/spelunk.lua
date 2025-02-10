return {
	-- persistent mark manager
	'EvWilson/spelunk.nvim',
	enabled = false, -- add when I use it
	dependencies = {
		'nvim-lua/plenary.nvim',         -- For window drawing utilities
		'nvim-telescope/telescope.nvim', -- Optional: for fuzzy search capabilities
	},
	config = function()
		require('spelunk').setup({
			base_mappings = {
				toggle                   = '<leader>bg', -- Toggle the UI open/closed
				add                      = '<leader>ba', -- Add a bookmark to the current stack
				next_bookmark            = 'NONE', -- Move to the next bookmark in the stack
				prev_bookmark            = 'NONE', -- Move to the previous bookmark in the stack
				search_bookmarks         = 'NONE', -- Fuzzy-find all bookmarks
				search_current_bookmarks = 'NONE', -- Fuzzy-find bookmarks in current stack
				search_stacks            = 'NONE', -- Fuzzy find all stacks
			},
			window_mappings = {
				cursor_down          = 'k',       -- Move the UI cursor down
				cursor_up            = 'j',       -- Move the UI cursor up
				bookmark_down        = '<C-j>',   -- Move the current bookmark down in the stack
				bookmark_up          = '<C-k>',   -- Move the current bookmark up in the stack
				goto_bookmark        = '<CR>',    -- Jump to the selected bookmark
				goto_bookmark_hsplit = 'x',       -- Jump to the selected bookmark in a new vertical split
				goto_bookmark_vsplit = 'v',       -- Jump to the selected bookmark in a new horizontal split
				delete_bookmark      = 'd',       -- Delete the selected bookmark
				next_stack           = '<Tab>',   -- Navigate to the next stack
				previous_stack       = '<S-Tab>', -- Navigate to the previous stack
				new_stack            = 'n',       -- Create a new stack
				delete_stack         = 'D',       -- Delete the current stack
				edit_stack           = 'E',       -- Rename the current stack
				close                = 'q',       -- Close the UI
				help                 = '?',       -- Open the help menu
			},
			-- Flag to enable directory-scoped bookmark persistence
			enable_persist = true,
			-- Prefix for the Lualine integration
			-- (Change this if your terminal emulator lacks emoji support)
			statusline_prefix = '🔖',
			-- Set UI orientation
			-- Type: 'vertical' | 'horizontal' | LayoutProvider
			-- Advanced customization: you may set your own layout provider for fine-grained control over layout
			-- See `types.lua` and `layout.lua` for guidance on setting this up
			orientation = 'vertical',
			-- Enable to show mark index in status column
			enable_status_col_display = false,
		})
	end
}
