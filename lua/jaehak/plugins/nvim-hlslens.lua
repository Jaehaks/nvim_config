return {
	'kevinhwang91/nvim-hlslens',
	-- event = 'CmdLineLeave',
	event = 'CmdLineEnter',
	opts = {
		calm_down = true, -- when the cursor is out of range of matched instance, clear highlight
		nearest_only = true, -- add lens only current matched instance
	},
	config = function (_, opts)
		local hlslens = require('hlslens')
		hlslens.setup(opts)

		local kopts = {noremap = true, silent = true}
		-- keymap
		vim.keymap.set('n', 'n', function ()
			local ok = pcall(function () vim.cmd('normal! ' .. vim.v.count1 .. 'n') end)
			if not ok then
				vim.notify('No searched words', vim.log.levels.WARN)
				return
			end
			hlslens.start()
		end, kopts)

		vim.keymap.set('n', 'N', function ()
			local ok = pcall(function () vim.cmd('normal! ' .. vim.v.count1 .. 'N') end)
			if not ok then
				vim.notify('No searched words', vim.log.levels.WARN)
				return
			end
			hlslens.start()
		end, kopts)

		vim.keymap.set('n', '*', function ()
			local ok = pcall(function() vim.cmd('normal! *N') end)
			if not ok then return end
			hlslens.start()
		end, kopts)

		vim.keymap.set('n', '#', function ()
			local ok = pcall(function() vim.cmd('normal! #') end)
			if not ok then return end
			hlslens.start()
		end, kopts)

		vim.keymap.set('n', 'g*', function ()
			local ok = pcall(function() vim.cmd('normal! g*') end)
			if not ok then return end
			hlslens.start()
		end, kopts)

		vim.keymap.set('n', 'g#', function ()
			local ok = pcall(function() vim.cmd('normal! g#') end)
			if not ok then return end
			hlslens.start()
		end, kopts)
	end
}
