return {
	-- it is useful to show git diff sign / but staging and commit is not 
	'lewis6991/gitsigns.nvim',
	enabled = true,
	event = 'VeryLazy',
	config = function ()
		local gitsigns = require('gitsigns')

		gitsigns.setup({
			signs = {
				add          = { text = '│' },
				change       = { text = '│' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
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
				end, {expr=true})

				map('n', '[h', function()
					if vim.wo.diff then return '[h' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, {expr=true})

				-- Actions
				-- map('n', '<leader>hs', gs.stage_hunk)
				-- map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
				-- map('n', '<leader>hS', gs.stage_buffer)
				map('n', '<leader>hr', gs.reset_hunk)
				map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
				map('n', '<leader>hu', gs.undo_stage_hunk)
				map('n', '<leader>hR', gs.reset_buffer)
				map('n', '<leader>hp', gs.preview_hunk)
				map('n', '<leader>hb', function() gs.blame_line{full=true} end)
				-- map('n', '<leader>ht', gs.toggle_current_line_blame)
				map('n', '<leader>hd', gs.diffthis)
				map('n', '<leader>hD', function() gs.diffthis('~') end)
				-- map('n', '<leader>td', gs.toggle_deleted)

				-- Text object
				-- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end
		})
	end
}