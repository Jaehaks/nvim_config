return {
{
	'MagicDuck/grug-far.nvim',
	keys = {
		-- open grug-far about current file, current word, it supports visual block
		{'<leader>sf', function ()
			require('grug-far').open({
				prefills = {
					search = vim.fn.expand('<cword>'),
					paths = vim.fn.expand('%')
				},
			})
		end,  desc = "Find and replace on current file", mode = {'n', 'x'} },

		-- open grug-far about project file
		{'<leader>sF', function ()
			require('grug-far').open({
				prefills = {
					search = vim.fn.expand('<cword>'),
				}
			})
		end,  desc = "Find and replace on all project files", mode = {'n', 'x'} },
	},
	opts = {
		engines = {
			ripgrep = {
				showReplaceDiff = false -- don't show Diff view
			}
		},
		windowCreationCommand = 'botright split', -- window location
		keymaps = {
			replace           = { n = '<localleader>r' }, -- replace all
			qflist            = { n = '<localleader>q' }, -- (not useful)
			syncLocations     = { n = '<localleader>s' }, -- replace all
			syncLine          = { n = '<localleader>l' }, -- replace one line
			close             = { n = 'q' },
			historyOpen       = { n = '<localleader>h' }, -- show replace history, it can be applied
			historyAdd        = { n = '<localleader>a' },
			refresh           = { n = '<localleader>f' }, -- (not useful)
			openLocation      = { n = '<localleader>o' }, -- move cursor to replace item, remaining focus grug-far
			gotoLocation      = { n = '<enter>' },        -- move cursor to replace item, focus to buffer
			pickHistoryEntry  = { n = '<enter>' },        -- apply history entry to replace window
			abort             = { n = '<localleader>c' }, -- (not useful)
			help              = { n = 'g?' },
			toggleShowCommand = { n = '<localleader>t' }, -- (not useful) show rg command
			swapEngine        = { n = '<localleader>e' }, -- (not useful) swap engine
		},
	}
}
}
-- 'chrisgrieser/nvim-rip-substitute' : it's ui is nice, I want to see line list to replace , but it only highlight in current view
