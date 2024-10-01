
------------ reload when neovim is focused --------------
local aug_NvimFocus = vim.api.nvim_create_augroup('aug_NvimFocus', {clear = true})
vim.api.nvim_create_autocmd({'FocusGained'}, {    -- inquire file reload when nvim focused
	group = aug_NvimFocus,
	pattern = '*',
	command = 'silent! checktime'	-- check the buffer is changed out of neovim
})



------------ TaskKill redundant Process --------------

local SystemCall = vim.api.nvim_create_augroup("SystemCall", { clear = true })

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
vim.api.nvim_create_autocmd({"LspAttach"}, {
	group = SystemCall,
	callback = function (args)
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)

		if client then
			if client.name == 'harper_ls' then
				table.insert(delete_process_list, GetProcessId('harper-ls.exe')[1])
			end
		end
	end
})

-- clear some procedure after VimLeave
vim.api.nvim_create_autocmd({"VimLeave"}, {
	group = SystemCall,
	callback = function ()
		-- delete shada.tmp files which are not deleted after shada is saved
		vim.fn.system('del /Q /F /S "' .. vim.fn.stdpath('data') .. '\\shada\\*tmp*"')

		-- terminate process in delete process
		local i = #delete_process_list
		while i > 0 do
			vim.fn.system('taskkill /F /PID ' .. delete_process_list[i])
			i = i - 1
		end
	end
})

-- Check redundant process and terminate at startup
vim.api.nvim_create_autocmd({"VimEnter"}, {
	group = SystemCall,
	callback = function ()
		local nvim_process = GetProcessId('nvim.exe')
		if #nvim_process <= 3 then
			vim.fn.system('taskkill /F /IM ' .. 'harper-ls.exe')
		end
	end
})



------------ Auto Trim white space at the end of line --------------
local aug_TrimWhiteSpace = vim.api.nvim_create_augroup("aug_TrimWhiteSpace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = '*',
	group = aug_TrimWhiteSpace,
	callback = function ()
		require('conform').format({
			lsp_fallback = false,
			async = true,
			formatters = {'trim_whitespace'}
		})
	end
})

------------ highlight when yank --------------
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function ()
		vim.highlight.on_yank()
	end
})

------------ Web Search --------------
-- for web search
vim.api.nvim_create_user_command("Google", function (opts)
	local query = opts.args:gsub(' ', '+')
	local url = 'https://www.google.com/search?q='
	os.execute('start brave ' .. url .. query)
end, {nargs = 1})

vim.api.nvim_create_user_command("Perplexity", function (opts)
	local query = opts.args:gsub(' ', '+')
	local url = 'https://www.perplexity.ai/search?q='
	os.execute('start brave ' .. url .. query)
end, {nargs = 1})

