return {
	-- provide floating window tool
	-- it cannot change floating window size, I think I will change to floaterm
	'carbon-steel/detour.nvim',
	enabled = true, -- floating help is required?
	ft = {'help'}, -- it used for help
	-- event = 'BufReadPost',
	config = function ()

		-- help with floating window
		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = "*",
			callback = function(event)
				local filetype = vim.bo[event.buf].filetype
				local file_path = event.match

				if file_path:match "/doc/" ~= nil then
					-- Only run if the filetype is a help file (filetype = help or markdown && file path = /doc)
					if filetype == "help" or filetype == "markdown" then
						-- Get the newly opened help window
						-- and attempt to open a Detour() float
						local help_win = vim.api.nvim_get_current_win()
						local ok = require("detour").Detour()
						--local ok = require("detour").DetourCurrentWindow()		-- open only current window

						-- DetourCurrentWindow() needs to locate cursor only current window (covered by detour floating window)
						-- so when I edit the other window buffer, it makes error that must be closed the Detour window first


 						-- If we successfully create a float of the help file
						-- Close the split
						if ok then
							vim.api.nvim_win_close(help_win, false)
						end
					end
				end
			end,
		})

		-- -- open terminal in floating window
		-- vim.keymap.set("n", '<leader>t', function ()
		-- 	local ok = require('detour').Detour()  -- open a detour popup
		-- 	if not ok then
		-- 		return
		-- 	end
		--
		-- 	vim.cmd.terminal()     -- open a terminal buffer
		-- 	vim.bo.bufhidden = 'delete' -- close the terminal when window closes
		-- 	vim.bo.filetype = 'terminal' -- force filetype to be terminal in normal mode
		-- 	vim.cmd.startinsert() -- go into insert mode
		--
		-- 	vim.api.nvim_create_autocmd({"TermClose"}, {
		-- 		buffer = vim.api.nvim_get_current_buf(),
		-- 		callback = function ()
		-- 			-- This automated keypress skips for you the "[Process exited 0]" message
		-- 			-- that the embedded terminal shows.
		-- 			vim.api.nvim_feedkeys('<CR>', 'n', false)
		-- 		end
		-- 	})
		-- end)
	end
}
