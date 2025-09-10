vim.api.nvim_create_augroup("UserSettings_AUTOCMD", { clear = true })
------------ reload when neovim is focused --------------
vim.api.nvim_create_autocmd({'FocusGained'}, {    -- inquire file reload when nvim focused
	group = 'UserSettings_AUTOCMD',
	pattern = '*',
	command = 'silent! checktime'	-- check the buffer is changed out of neovim
})


------------ Change pwd to project folder --------------
vim.api.nvim_create_autocmd({'BufRead', 'BufWinEnter', 'LspAttach'}, {    -- inquire file reload when nvim focused
	group = 'UserSettings_AUTOCMD',
	pattern = '*',
	callback = function (ev)
		local root = require('jaehak.core.utils').GetRoot(ev.buf)
		vim.cmd('lcd ' .. root)
	end
})


------------ TaskKill redundant Process --------------

-- TODO: sometimes harper-ls.exe doesn't terminate properly. so force to exit this

local delete_process_list = {}
-- get process id of specific lsp to add delete list when VimLeave
-- vim.api.nvim_create_autocmd({"LspAttach"}, {
-- 	group = 'UserSettings_AUTOCMD',
-- 	callback = function (args)
-- 		local client_id = args.data.client_id
-- 		local client = vim.lsp.get_client_by_id(client_id)
--
-- 		if client then
-- 			-- insert recent harper-ls
-- 			if client.name == 'harper_ls' then
-- 				local harper_ls_tbl = GetProcessId('harper-ls.exe')
-- 				table.insert(delete_process_list, harper_ls_tbl[1])
-- 			end
--
-- 			-- insert recent matlab-ls
-- 			-- matlab lsp executes two process matlab.exe and MATLAB.exe
-- 			-- and the process run some times after lsp is executes
-- 			if client.name == 'matlab_ls' then
-- 				local attempts = 0
-- 				local max_attempts = 5
-- 				local timer = vim.loop.new_timer()
-- 				local matlab_tbl = {}
-- 				timer:start(3000, 1000, vim.schedule_wrap(function() -- start(start delay[ms], repeat[ms], callback )
-- 					attempts = attempts + 1
-- 					if next(matlab_tbl) or attempts >= max_attempts then
-- 						timer:stop()
-- 						table.insert(delete_process_list, matlab_tbl[1])
-- 						table.insert(delete_process_list, matlab_tbl[2])
-- 						if attempts >= max_attempts then
-- 							print('over timer')
-- 						end
-- 					end
-- 					matlab_tbl = GetProcessId('matlab.exe')
-- 				end))
--
-- 			end
-- 		end
-- 	end
-- })



-- clear some procedure after VimLeave
if vim.g.has_win32 then
vim.api.nvim_create_autocmd({"VimEnter"}, {
	group = 'UserSettings_AUTOCMD',
	callback = function ()
		-- delete shada.tmp files which are not deleted after shada is saved
		-- vim.fn.system('del /Q /F /S "' .. require('jaehak.core.paths').data_dir .. '\\shada\\*tmp*"')
		local shada_dir = require('jaehak.core.paths').data_dir .. '\\shada\\'
		local iter, _ = vim.uv.fs_scandir(shada_dir)

		while true do
			local name, type = vim.uv.fs_scandir_next(iter)
			if not name then break end
			if name:find("tmp.x") then
				local full_path = shada_dir .. name
				local ok, unlink_err = vim.uv.fs_unlink(full_path)
				if not ok then
					print('UserError : Fail to delete tmp file')
				end
			end
		end

		-- terminate process in delete process
		-- local i = #delete_process_list
		-- while i > 0 do
		-- 	vim.fn.system('taskkill /F /PID ' .. delete_process_list[i])
		-- 	i = i - 1
		-- end
	end
})
end

-- Check redundant process and terminate at startup
-- vim.api.nvim_create_autocmd({"BufReadPre", "BufNewFile"}, {
-- 	group = 'UserSettings_AUTOCMD',
-- 	callback = function ()
-- 		local nvim_process = GetProcessId('nvim.exe')
-- 		if #nvim_process <= 3 then
-- 			local harper_ls_process = #GetProcessId('harper-ls.exe')
-- 			if harper_ls_process > 0 then
-- 				vim.fn.system('taskkill /F /IM ' .. 'harper-ls.exe')
-- 			end
-- 		end
-- 	end,
-- 	once = true,
-- })

-- auto stop lsp when all buffers related the lsp are deleted
-- vim.api.nvim_create_autocmd("BufDelete", {
-- 	callback = function(args)
-- 		print('buf delete')
-- 		local bufnr = args.buf
-- 		local clients = vim.lsp.get_active_clients({bufnr = bufnr})
-- 		for _, client in ipairs(clients) do
-- 			-- print(client.id)
-- 			print(#client.attached_buffers)
-- 			-- Check if the client is only attached to this buffer
-- 			if #client.attached_buffers == 0 then
-- 				-- vim.lsp.stop_client(client.id)
-- 				vim.cmd('LspStop ' .. client.id)
-- 				print(string.format("Stopped LSP client %s", client.name))
-- 			end
-- 		end
-- 	end,
-- })

------------ Auto Trim white space at the end of line --------------
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = '*',
	group = 'UserSettings_AUTOCMD',
	callback = function ()
		require('conform').format({
			lsp_fallback = false,
			async = true,
			formatters = {'trim_whitespace'}
		})
	end
})


------------ Auto save when InsertLeave --------------
local NotHasFileName = function ()
	local filename = vim.fn.expand('%:t')
	return filename == '' or filename == '[No Name]'
end

vim.opt.updatetime = 500
vim.api.nvim_create_autocmd('CursorHold', {
	pattern = '*',
	group = 'UserSettings_AUTOCMD',
	callback = function (event)

		if vim.bo.buftype ~= '' or
			NotHasFileName() or
			not vim.bo.modified or
			vim.b[event.buf].disable_aug_TrimWhiteSpace then
			return
		end

		if vim.bo[event.buf].filetype == 'gitcommit' or
		   vim.bo[event.buf].filetype == 'NeogitStatus' then
			return
		end

		vim.api.nvim_exec_autocmds('BufWritePre', {buffer = 0}) -- force execute BufWritePre event
		local ok, _ = pcall(function () vim.cmd('write') end)
		if not ok then -- when write is protected, do not write anymore in this buffer
			vim.notify('AutoCmd : Failed to write this file', vim.log.levels.WARN)
			vim.b[event.buf].disable_aug_TrimWhiteSpace = true
			return
		end
		vim.api.nvim_exec_autocmds('BufWritePost', {buffer = 0}) -- force execute BufWritePost event
	end
})

------------ highlight when yank --------------
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = '*',
	group = 'UserSettings_AUTOCMD',
	callback = function ()
		vim.highlight.on_yank()
	end
})
















