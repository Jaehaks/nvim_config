------------ reload when neovim is focused --------------
vim.api.nvim_create_autocmd({'FocusGained'}, {    -- inquire file reload when nvim focused
	group = 'UserSettings',
	pattern = '*',
	command = 'silent! checktime'	-- check the buffer is changed out of neovim
})



------------ TaskKill redundant Process --------------

-- TODO: sometimes harper-ls.exe doesn't terminate properly. so force to exit this
-- get recent process id
local function GetProcessId(name)
	-- skip=1 : erase first line of output
	-- tokens=3 : catch 3rd item which is sliced with delimiter ',' from output
	-- processid,creationdate : show creationdate and sort by recently
	local cmd = [[for /f "usebackq skip=1 tokens=3 delims=," %a in (`wmic process where name^="]]
				.. name
				.. [[" get processid^,creationdate /format:csv ^| sort -r`) do @echo %a]]
	local outputs = vim.fn.system(cmd)
	local ids = {}
	for id in outputs:gmatch('(%d+)') do
		table.insert(ids, id)
	end
	return ids
end

local delete_process_list = {}
-- get process id of specific lsp to add delete list when VimLeave
-- vim.api.nvim_create_autocmd({"LspAttach"}, {
-- 	group = 'UserSettings',
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

vim.api.nvim_create_user_command("GetProcessId", function (opts)
	local tbl = GetProcessId('matlab.exe')
	vim.print(tbl)
end, {nargs = 1})


-- clear some procedure after VimLeave
if vim.g.has_win32 then
vim.api.nvim_create_autocmd({"VimEnter"}, {
	group = 'UserSettings',
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
-- 	group = 'UserSettings',
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
	group = 'UserSettings',
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
	group = 'UserSettings',
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
		local ok, err = pcall(vim.cmd, 'write')
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
	group = 'UserSettings',
	callback = function ()
		vim.highlight.on_yank()
	end
})




------------ vim.ui.select() -----------
-- set autocmd when vim.ui.select() is executed
local origin_vim_ui_select = vim.ui.select
-- vim.ui.select = function (items, opts, on_choice)
-- 	vim.api.nvim_exec_autocmds('User', {
-- 		pattern = 'VimUISelect'
-- 	})
--
-- 	local snacks = require('snacks')
-- 	if package.loaded['snacks'] then
-- 		snacks.picker.select(items, opts, on_choice)
-- 	else
-- 		vim.schedule(function ()
-- 			snacks.picker.select(items, opts, on_choice)
-- 		end)
-- 	end
-- end















