return {
	-- it is useful to show git diff sign / but staging and commit is not
	'lewis6991/gitsigns.nvim',
	event = 'BufReadPost',
	opts = {
		signs = {
			add          = { text = '│' },
			change       = { text = '│' },
			delete       = { text = '_' },
			topdelete    = { text = '‾' },
			changedelete = { text = '~' },
			untracked    = { text = '┆' },
		},
		signs_staged_enable = true,
		signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
		sign_priority = 10,
		numhl = true,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map('n', ']h', function()
				if vim.wo.diff then return ']h' end
				vim.schedule(function() gs.next_hunk() end)
				return '<Ignore>'
			end, {expr=true, desc = 'find next hunk'})

			map('n', '[h', function()
				if vim.wo.diff then return '[h' end
				vim.schedule(function() gs.prev_hunk() end)
				return '<Ignore>'
			end, {expr=true, desc = 'find prev hunk'})

			-- Actions
			map('n', '<leader>hp', gs.preview_hunk, {desc = 'preview hunk in current line'})
			map('n', '<leader>hn', gs.next_hunk, {desc = 'go to next hunk in current line'})
			map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'commit message in current line'})
			map('n', '<leader>hl', gs.setloclist, {desc = 'show gitsign list'})
			map('n', '<leader>hd', gs.toggle_deleted, {desc = 'show all deleted hunks'})
			map('n', '<leader>hh', gs.toggle_linehl, {desc = 'highlight hunks in addition to signs'})

			map('n', '<leader>hs', gs.stage_buffer, {desc = 'stage all hunks in current buffer'}) --  git add this buffer
			map('n', '<leader>hS', gs.reset_buffer_index, {desc = 'reset staged all hunks in current buffer'}) --  git add this buffer
			map({'n', 'v'}, '<leader>ha', ':Gitsigns stage_hunk<CR>', {desc = 'stage current contiguous hunks'}) --  git add this hunk
			map({'n', 'v'}, '<leader>hA', ':Gitsigns undo_stage_hunk<CR>', {desc = 'undo staged current contiguous hunks'}) --  git add this hunk

			-- reset_hunk() : reset unstaged hunk, it deletes the modified hunk

			-- set highlights for gitsign
			vim.api.nvim_set_hl(0, 'GitSignsAdd', {link = 'GitSignsChange'})
			vim.api.nvim_set_hl(0, 'GitSignsAddNr', {link = 'GitSignsChange'})
			vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', {link = 'GitSignsStagedChange'})
			vim.api.nvim_set_hl(0, 'GitSignsStagedAddNr', {link = 'GitSignsStagedChange'})

		end
	},
}
