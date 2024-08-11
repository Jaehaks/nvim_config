return {
{
	'MagicDuck/grug-far.nvim',
    config = function()
		local grugfar = require('grug-far')
		grugfar.setup({
			windowCreationCommand = 'botright split', -- window location
			keymaps = {
				replace           = { n = '<localleader>r' }, -- replace all
				qflist            = { n = '<localleader>q' }, -- (not useful) 
				syncLocations     = { n = '<localleader>s' }, -- replace all
				syncLine          = { n = 'o' },              -- replace one line
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
		})

		-- open grug-far about current file, current word
		vim.keymap.set('n', '<leader>sf', function ()
			grugfar.grug_far({
				prefills = {
					search = vim.fn.expand('<cword>'),
					paths = vim.fn.expand('%')
				}
			})
		end, { desc = "Find and replace on current file" })

		-- BUG: it takes the word when I call this function twice
		-- open grug-far about curretn file, visual range
		vim.keymap.set('x', '<leader>sf', function ()
			grugfar.with_visual_selection({
				prefills = {
					paths = vim.fn.expand('%')
				}
			})
		end, { desc = "Find and replace on current file" })

		-- open grug-far about project file
		vim.keymap.set('n', '<leader>sF', function ()
			grugfar.grug_far({
				prefills = {
					search = vim.fn.expand('<cword>'),
				}
			})
		end, { desc = "Find and replace on current file" })

    end
}
}
-- 'chrisgrieser/nvim-rip-substitute' : it's ui is nice, I want to see line list to replace , but it only highlight in current view 
