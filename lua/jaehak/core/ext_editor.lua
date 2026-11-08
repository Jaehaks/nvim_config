-- For external editor
-- Opens a temporary file as a floating window, waits until the buffer is closed, and then terminates.
-- command : nvim --clean -l remote-edit.lua <line> <file>


-- temp file path from parent program (claude , ...)
local line = arg[1]
local temp_file = arg[2]

-- this lua file is executed by only child nvim instance. (which has %NVIM% env vars)
-- if nvim which called this lua file is not nested, exit
local servername = vim.env.NVIM
if not servername or servername == '' then
	io.stderr:write('ext_editor Error : $NVIM is not set. Current nvim is not child instance\n')
	os.exit(1) -- set exit code it not 0
end

-- Absolute path based on claude's cwd for relative path form of temp_file
local file = vim.fn.fnamemodify(temp_file, ':p')

-- connect rpc socket and get channel of parent neovim
-- 'return from socketconnect' means channel number between parent and child neovim visible from the child's side
-- chan is needed to send command from child to parent
local ok, chan = pcall(vim.fn.sockconnect, 'pipe', servername, { rpc = true })
if not ok or chan == 0 then
	io.stderr:write('ext_editor Error : cannot connect to ' .. servername .. '\n')
	os.exit(1)
end

-- pchan means channel number between parent and child neovim visible from the parents's side
-- pchan is needed to send command from parent to child
local pchan = vim.rpcrequest(chan, 'nvim_get_api_info')[1]


-- open temp file to parent neovim
-- get the return value of open() = bufnr
local bufnr = vim.rpcrequest(chan, 'nvim_exec_lua',
	[[return require('jaehak.core.ext_editor_buf').open(...)]], { file, pchan })

-- wait to save this child neovim process until the editor is closed.
vim.wait(2 ^ 31 - 1, function()
	return vim.g.ext_editor_done
		or vim.tbl_isempty(vim.api.nvim_get_chan_info(chan))
end, 1000)

--- workflow
-- 1) make rpc socket channel between parent and child neovim
-- 2) sockconnect() returns channel number from child side. It is needed to send cmd from child to parent to buffer open.
-- 3) rpcrequest() returns result of function which is sent to parent neovim.
-- 	  so get pchan to send command from parent to child neovim
-- 4) 'ext_editor_buf's open() is executed in parent neovim. It makes buffer of file.
--    It registers autocmd 'BufWipeout' in parent neovim
-- 5) child neovim process is hanging on until wait condition is true (ext_editor_done in child neovim)
-- 6) when the buffer is closed, BufWipeout autocmd is executed, it makes new var 'ext_editor_done' in
-- 	  child neovim.
-- 7) then, the child neovim process is quit. and return to terminal which call this child process


--- Q&A
-- rpcrequest() : send command and wait function results.
-- rpcnotify() : send command and don't wait results. go to next line
-- vim.rpcrequest(chan, 'nvim_exec_lua',
-- 	'vim.print(...)', {line, temp_file,file})
