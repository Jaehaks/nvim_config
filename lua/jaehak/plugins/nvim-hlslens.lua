return {
	'kevinhwang91/nvim-hlslens',
	-- event = 'CmdLineLeave',
	event = 'CmdLineEnter',
	dependencies = {
		'Isrothy/neominimap.nvim',
	},
	opts = {
		calm_down = true, -- when the cursor is out of range of matched instance, clear highlight
		nearest_only = true, -- add lens only current matched instance
	},
	config = function (_, opts)
		local hlslens = require('hlslens')
		hlslens.setup(opts)

		local kopts = {noremap = true, silent = true}
		local neominimap = require('neominimap.api')
		-- local min_line = 200 -- turn on minimap in file which has more lines than this value
		local min_line = 2 -- turn on minimap in file which has more lines than this value

		-- function : turn on / off in search mode
		local check_search_highlight = function ()
			local total_line = vim.api.nvim_buf_line_count(0)
			if vim.v.hlsearch == 1 and not neominimap.enabled() and total_line > min_line then

				local winid_list = vim.api.nvim_list_wins()
				local winid_cur = vim.api.nvim_get_current_win()
				local winid_other = vim.tbl_filter(function(id)
					return id ~= winid_cur
				end, winid_list)

				vim.opt_local.sidescrolloff = 36
				neominimap.enable()
				neominimap.win.disable(winid_other) -- turn off neominimap except current window
				neominimap.win.enable({winid_cur}) -- turn on neominimap in current window

			elseif vim.v.hlsearch == 0 and neominimap.enabled() then
				vim.opt_local.sidescrolloff = 0
				neominimap.disable()
			end
		end

		-- autocmd integrated with neominimap
		local aug_Neominimap = vim.api.nvim_create_augroup('aug_Neominimap', {clear = true})
		vim.api.nvim_create_autocmd('CmdLineLeave', {
			group = aug_Neominimap,
			pattern = {'/', '?'},
			callback = function ()
				vim.schedule(function ()
					local word = vim.fn.searchcount({recompute = 1})
					if word and word.total > 0 then
						check_search_highlight()
					end
				end)
			end,
		})

		vim.api.nvim_create_autocmd('CursorMoved', {
			group = aug_Neominimap,
			callback = function ()
				if not vim.g.neominimap_manual then -- if not manual mode,
					if vim.v.hlsearch == 0 and neominimap.enabled() then
						vim.opt_local.sidescrolloff = 0
						neominimap.disable()
					end
				end
			end,
		})

		-- keymap
		vim.keymap.set('n', 'n', function ()
			local ok = pcall(function () vim.cmd('normal! ' .. vim.v.count1 .. 'n') end)
			if not ok then
				vim.notify('No searched words', vim.log.levels.WARN)
				return
			end
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', 'N', function ()
			local ok = pcall(function () vim.cmd('normal! ' .. vim.v.count1 .. 'N') end)
			if not ok then
				vim.notify('No searched words', vim.log.levels.WARN)
				return
			end
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', '*', function ()
			local ok = pcall(function() vim.cmd('normal! *N') end)
			if not ok then return end
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', '#', function ()
			local ok = pcall(function() vim.cmd('normal! #') end)
			if not ok then return end
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', 'g*', function ()
			local ok = pcall(function() vim.cmd('normal! g*') end)
			if not ok then return end
			hlslens.start()
			check_search_highlight()
		end, kopts)

		vim.keymap.set('n', 'g#', function ()
			local ok = pcall(function() vim.cmd('normal! g#') end)
			if not ok then return end
			hlslens.start()
			check_search_highlight()
		end, kopts)
	end
}
