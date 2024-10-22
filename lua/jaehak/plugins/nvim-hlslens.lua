return {
	'kevinhwang91/nvim-hlslens',
	dependencies = {
		'Isrothy/neominimap.nvim',
	},
	config = function ()
		local hlslens = require('hlslens')
		hlslens.setup({
			calm_down = true, -- when the cursor is out of range of matched instance, clear highlight
			nearest_only = true, -- add lens only current matched instance
		})

		local kopts = {noremap = true, silent = true}
		local neominimap = require('neominimap')
		local neovar = require('neominimap.variables')
		local min_line = 200 -- turn on minimap in file which has more lines than this value

		-- function : turn on / off in search mode
		local check_search_highlight = function ()
			local total_line = vim.api.nvim_buf_line_count(0)
			if vim.v.hlsearch == 1 and not neovar.g.enabled and total_line > min_line then
				vim.opt_local.sidescrolloff = 36
				neominimap.on()
			elseif vim.v.hlsearch == 0 and neovar.g.enabled then
				vim.opt_local.sidescrolloff = 0
				neominimap.off()
			end
		end

		-- autocmd integrated with neominimap
		local aug_Neominimap = vim.api.nvim_create_augroup('aug_Neominimap', {clear = true})
		vim.api.nvim_create_autocmd('CmdLineLeave', {
			group = aug_Neominimap,
			pattern = {'/', '?'},
			callback = function ()
				vim.schedule(function ()
					if vim.fn.searchcount({recompute = 1}).total > 0 then -- check searched word is existed
						check_search_highlight()
					end
				end)
			end,
		})

		vim.api.nvim_create_autocmd('CursorMoved', {
			group = aug_Neominimap,
			callback = function ()
				if vim.v.hlsearch == 0 and neovar.g.enabled then
					neominimap.off()
				end
			end,
		})

		-- keymap
		vim.keymap.set('n', 'n', function ()
			vim.cmd('normal! ' .. vim.v.count1 .. 'n')
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', 'N', function ()
			vim.cmd('normal! ' .. vim.v.count1 .. 'N')
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', '*', function ()
			vim.cmd('normal! *N')
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', '#', function ()
			vim.cmd('normal! #')
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', 'g*', function ()
			vim.cmd('normal! g*')
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', 'g#', function ()
			vim.cmd('normal! g#')
			hlslens.start()
			check_search_highlight()
		end, kopts)
	end
}
