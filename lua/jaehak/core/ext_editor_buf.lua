--- when child nvim process has rpcrequest to the parent nvim,
--- parent nvim executes this lua file to open buffer which is given from argument by proper way
local M = {}

---@class ext_editor.bufopts
---@field bo? vim.bo
---@field wo? vim.bo
---@field win? vim.api.keyset.win_config
---@field posthook? fun(bufnr: integer, winnr:integer)
local default_opts = {
	bo = {
		buflisted = false, -- don't list in :ls
		swapfile = false,  -- don't make swapfile
	},
	wo = {
		-- winfixheight = true, -- for split mode
		winbar = 'Prompt (:wq to close)'
	},
	win = {
		--- floating mode
		relative = 'editor',
		width = 1,
		height = 0.3,
		border = 'none',

		--- split mode
		-- split = 'below',   -- split window at bottom
		-- win = -1,          -- botright for split
		-- height = 0.3,
	},
	posthook = nil,
}

M.config = vim.deepcopy(default_opts)

--- return cell numbers for height / width about 0~
---@param v number ratio / cell numbers
---@param total number entire cell numbers for ratio
---@return integer
local function size(v, total)
	return math.floor(v <= 1 and total * v or v)
end

--- open file to nvim parent process
---@param file string absolute file path
---@param pchan any channel info of parent neovim
---@param cfg ext_editor.bufopts
---@return integer buffer id
function M.open(file, pchan, cfg)
	cfg = vim.tbl_deep_extend('force', M.config, cfg or {})

	-- prev winnr of nvim terminal which called child nvim process
	local prev_winnr = vim.api.nvim_get_current_win()

	-- add file to buffer list / set buf opts
	local bufnr = vim.fn.bufadd(file)
	vim.b[bufnr].ext_editor = true -- new variable to ignore markdown lsp
	vim.bo[bufnr].buflisted = false
	vim.bo[bufnr].bufhidden = 'wipe'
	if cfg.bo.swapfile ~= nil then -- set opts before adding buffer
		vim.bo[bufnr].swapfile = cfg.bo.swapfile
	end
	vim.fn.bufload(bufnr)
	for k, v in pairs(cfg.bo) do -- set opts after adding buffer
		if k ~= 'swapfile' then vim.bo[bufnr][k] = v end
	end

	-- set win opts
	local width = size(cfg.win.width or 1, vim.o.columns)
	local height = size(cfg.win.height or 10, vim.o.lines)
	local bottom = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus == 3 and 1 or 0)
	local wincfg = vim.tbl_extend('force', cfg.win, {width = width, height = height})

	if not wincfg.split then -- if floating mode
		wincfg.relative = cfg.win.relative or 'editor'
		wincfg.width = width
		wincfg.height = height
		wincfg.row = cfg.win.row or (bottom - height)
		wincfg.col = cfg.win.col or math.floor((vim.o.columns - width) / 2)
	end
	-- open window and show file contents
	local winnr = vim.api.nvim_open_win(bufnr, true, wincfg)
	vim.cmd.stopinsert()
	for k, v in pairs(cfg.wo) do
		vim.wo[winnr][k] = v
	end

	-- local location = 1
	-- local function time_checking()
	-- 	local sec, usec = vim.uv.gettimeofday()
	-- 	if sec ~= nil and usec ~= nil then
	-- 		local ms = math.floor(usec / 1000)
	-- 		local time_str = os.date("%H:%M:%S", sec) .. string.format(".%03d", ms)
	-- 		vim.print('callback time(' .. location .. ') : ' .. time_str)
	-- 		location = location+1
	-- 	end
	-- end

	-- return to terminal buffer when buffer is removed
	-- vim.api.nvim_create_autocmd('WinClosed', {
	vim.api.nvim_create_autocmd('BufWipeout', {
		-- pattern = tostring(winnr),
		buffer = bufnr,
		once = true,
		callback = function()
			-- time_checking()
			-- Snacks.profiler.start()
			vim.schedule(function()
				-- set global variable 'ext_editor_done = true' to child neovim process
				-- time_checking()
				-- Snacks.profiler.stop()
				if pchan then
					pcall(vim.rpcnotify, pchan, 'nvim_set_var', 'ext_editor_done', true)
				end

				-- return to previous terminal
				if vim.api.nvim_win_is_valid(prev_winnr) then
					vim.api.nvim_set_current_win(prev_winnr)
					vim.cmd.startinsert()
				end
			end)
		end,
	})

	-- post hook
	if cfg.posthook then cfg.posthook(bufnr, winnr) end

	return bufnr
end

return M
