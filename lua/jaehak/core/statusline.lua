local api      = vim.api
local uv       = vim.uv
local s_format = string.format
local group    = api.nvim_create_augroup("StlUserDefined", { clear = true })
local _devicons_ok, _devicons = pcall(require, 'nvim-web-devicons')


-- ==========================================
-- get cache about statusline
-- ==========================================

---@class stl.cache_buf
---@field fileicon string
---@field filename string
---@field filesize string
---@field fileencoding string
---@field fileformat string
---@field filetype string
---@field modified string
---@field bufnr string
---@field git_branch string
---@field diagnostics string
---@field lsp string

--- cache variable
---@class stl.cache
---@field mode_inactive string
---@field mode string
---@field sep_left string
---@field sep_right string
---@field bufs stl.cache_buf[]
local cache = {
	mode_inactive = "%#StlModeInactive# INACTIVE %#StlModeInactiveSep#",
	mode = "",
	bufs = {},
	sep = {
		left = "%#StlDefault#  ",
		right = "%#StlDefault#  ",
		right_pos = "%#StlDefault#",
	}
}

--- get cache info about buf, if the buffer is new, create and initialize properties
---@param buf integer buffer id
---@return stl.cache_buf buffer info table for status line
local function get_buf_cache(buf)
	if not cache.bufs[buf] then
		cache.bufs[buf] = {
		    fileicon = "",
		    filename = "",
		    filesize = "",
		    fileencoding = "",
		    fileformat = "",
		    filetype = "",
		    modified = "",
		    bufnr = "",
		    git_branch = "",
		    diagnostics = "",
		    lsp = "",
		}
	end
	return cache.bufs[buf]
end

--- clear specific cache
---@param buf integer buffer id
local function clear_buf_cache(buf)
	local c = cache.bufs[buf]
	if not c then return end

	for k, _ in pairs(c) do
		c[k] = ""
	end
end

--- delete cache if buffer is deleted
api.nvim_create_autocmd("BufDelete", {
	group = group,
	callback = function(args)
		cache.bufs[args.buf] = nil
	end
})

-- ==========================================
-- Setting highlight
-- ==========================================
--- get colorcode of bg or fg from highlight group name
---@param name string
---@param is_bg boolean? get background color if true
local function extract_hl(name, is_bg)
	local hl = api.nvim_get_hl(0, { name = name, link = false }) -- it has integer code, so we need to change it to hex code
	local color_int = is_bg and hl.bg or hl.fg
	return color_int and s_format("#%06x", color_int) or nil
end

--- setting highlights group
local function setup_highlights()
	-- default highlight
	local bg = '#252c3f'
	local fg = '#5b8fff'


	-- highlight color for modes
	local mode_colors = {
		Normal  = extract_hl('Function')   or '#89b4fa', -- n
		Insert  = extract_hl('Keyword')    or '#a6e3a1', -- i, ic, s, S
		Visual  = extract_hl('Type')       or '#cba6f7', -- v, V, ^V
		Command = extract_hl('Identifier') or '#f9e2af', -- c, t
		Replace = extract_hl('Statement')  or '#f38ba8', -- r, R
		Inactive = '#adadad',
	}
	for mode, color in pairs(mode_colors) do
		api.nvim_set_hl(0, 'StlMode' .. mode, { bg = color, fg = '#1e1e2e', bold = true })
		api.nvim_set_hl(0, 'StlMode' .. mode .. 'Sep', { bg = bg, fg = color })
	end

	-- other components
	api.nvim_set_hl(0, 'StlDefault',      { bg = bg,        fg = fg })
	api.nvim_set_hl(0, 'StlFileSize',     { bg = bg,        fg = '#FFD800' }) -- filesize
	api.nvim_set_hl(0, 'StlGitBranch',    { bg = bg,        fg = '#FF00FF' }) -- git branch
	api.nvim_set_hl(0, 'StlFileIcon',     { bg = bg,        fg = '#607db9' }) -- filename
	api.nvim_set_hl(0, 'StlFileName',     { bg = bg,        fg = '#82aaff' }) -- filename
	api.nvim_set_hl(0, 'StlFileEncoding', { bg = bg,        fg = '#82aaff' }) -- filename
	api.nvim_set_hl(0, 'StlFileFormat',   { bg = bg,        fg = '#82aaff' }) -- filename
	api.nvim_set_hl(0, 'StlFileType',     { bg = bg,        fg = '#82aaff' }) -- filename
	api.nvim_set_hl(0, 'StlBufnr',        { bg = bg,        fg = '#82aaff' }) -- filename
	api.nvim_set_hl(0, 'StlModified',     { bg = bg,        fg = '#FFFF00' }) -- modified sign
	api.nvim_set_hl(0, 'StlPos',          { bg = '#89b4fa', fg = '#1e1e2e', bold = true })
	api.nvim_set_hl(0, 'StlPosSep',       { bg = bg,        fg = '#89b4fa' })
end

-- ==========================================
-- Main function
-- ==========================================
--- rendering status line, set statusline option
---@param winid integer window id
local function update_statusline(winid)
	if not api.nvim_win_is_valid(winid) then return end -- valid check
	if api.nvim_win_get_config(winid).zindex then return end -- disable statusline in floating window

	-- get mode using statusline form (mode is window property)
	local mode_str = (winid == api.nvim_get_current_win()) and cache.mode or  cache.mode_inactive

	-- get status line cache information of buffer in current window
	local bufnr = api.nvim_win_get_buf(winid)
	local cache_buf = cache.bufs[bufnr]
	if not cache_buf then return end

	-- set components to left/center/right
	local left = mode_str ..
				 cache_buf.filesize ..
				 cache_buf.git_branch
	local center = cache_buf.modified .. " " ..
				   cache_buf.fileicon .. " " ..
				   cache_buf.filename ..
				   cache_buf.diagnostics
	local right = cache_buf.fileencoding .. (cache_buf.fileencoding == "" and "" or cache.sep.right) ..
				  cache_buf.fileformat .. (cache_buf.fileformat == "" and "" or cache.sep.right) ..
				  cache_buf.filetype .. (cache_buf.fileformat == "" and "" or cache.sep.right) ..
				  cache_buf.bufnr .. ' ' ..
				  "%#StlPosSep#%#StlPos# [%l/%L]:%c "

	vim.wo[winid].statusline = left .. '%=' .. center .. '%=' .. right
end

--- rendering status line for all windows in current tab
local function update_all_statusline()
	for _, win in ipairs(api.nvim_list_wins()) do
		update_statusline(win)
	end
end

--- rendering status line for all windows related with specific buffer
---@param bufnr integer buffer id
local function update_buf_statusline(bufnr)
	for _, win in ipairs(api.nvim_list_wins()) do
		if api.nvim_win_get_buf(win) == bufnr then
			update_statusline(win)
		end
	end
end

api.nvim_create_autocmd("WinEnter", {
	group = group,
	callback = update_all_statusline,
})

-- ==========================================
-- Set git signs changes
-- ==========================================

--- set git info to cache
---@param buf integer
local function caching_git_info(buf)
	if not api.nvim_buf_is_valid(buf) then return end

	local branch = vim.b[buf].gitsigns_head -- get gitsigns.nvim data
	local cache_buf = get_buf_cache(buf)
	cache_buf.git_branch = (branch and branch ~= "") and "%#StlGitBranch# " .. branch or ""
end

--- autocmd to update git status for all buffers
api.nvim_create_autocmd({'FocusGained', 'BufEnter'}, {
	group = group,
	callback = function()
		local gitsigns = package.loaded['gitsigns']
		if not gitsigns then return end

		vim.schedule(function ()
			gitsigns.refresh()
		end)
	end,
})

--- It is called after refresh() for each buffers, update statusline
api.nvim_create_autocmd("User", {
	group = group,
	pattern = "GitSignsUpdate",
	callback = function(args)
		caching_git_info(args.buf)
		update_buf_statusline(args.buf)
	end,
})

-- ==========================================
-- Set File information
-- ==========================================

local suffix = { "", "k", "M", "G" }
--- convert to human readable size
---@param byte_size integer
---@return string
local function get_readable_size(byte_size)
	local size = byte_size
	local i = 1
	while size > 1024 and i < 4 do size, i = size / 1024, i + 1 end
	return s_format("%%#StlFileSize# %.1f%s ", size, suffix[i])
end

--- save file information to cache
---@param buf integer buffer id
local function caching_file_info(buf)
	if not api.nvim_buf_is_valid(buf) then return end
	local cache_buf  = get_buf_cache(buf)
	local bo = vim.bo[buf]
	local file = api.nvim_buf_get_name(buf)
	local filename = vim.fn.fnamemodify(file, ":t")
	local ext      = vim.fn.fnamemodify(file, ":e")

	-- set buffer number
	cache_buf.bufnr = '%#StlBufnr#' .. buf
	local _bufman = package.loaded['bufman']
	if _bufman then
		cache_buf.bufnr = cache_buf.bufnr .. ':' .. _bufman.get_bufcount()
	end

	-- if it is not normal buffer
	if bo.buftype ~= "" then
		clear_buf_cache(buf) -- prevent contamination when help file is changed to normal buffer using ':e'
		if bo.buftype == 'help' then
			cache_buf.filename = '%#StlFileIcon# 󰋖 HELP %#StlFileName#' .. filename
		elseif bo.buftype == 'terminal' then
			cache_buf.filename = '%#StlFileIcon#  TERM %#StlFileName#' .. filename
		else
			cache_buf.filename = '%#StlDefault# %t'
		end
		return
	end

	-- if new file
	if file == "" then
		cache_buf.filesize = ""
		cache_buf.filename = "%#StlFileName# [No Name]"
		return
	end

	-- 1) set file size
	local stat = uv.fs_stat(file)
	if stat then
		cache_buf.filesize = get_readable_size(stat.size)
	end

	-- 2) set encoding info
	cache_buf.fileencoding = '%#StlFileEncoding#' .. (bo.fileencoding ~= "" and bo.fileencoding or vim.o.encoding) -- if new buffer, it follows by neovim inherit encoding
	cache_buf.fileformat = '%#StlFileFormat#' .. bo.fileformat
	cache_buf.filetype = '%#StlFileType#' .. bo.filetype

	-- 3) icon and filename
	local icon, icon_hl = "", "StlFileName"
	if _devicons_ok then
		local ic, hl = _devicons.get_icon(filename, ext, { default = true })
		icon, icon_hl = ic or "", hl or "StlFileName"
	end
	cache_buf.fileicon = '%#' .. icon_hl .. '#' .. icon
	cache_buf.filename = '%#StlFileName#%t'
end

--- save modified information to cache
---@param buf integer buffer id
local function caching_modified(buf)
  if not api.nvim_buf_is_valid(buf) then return end
  local cache_buf = get_buf_cache(buf)
  local bo = vim.bo[buf]

  local mod = bo.modified and "%#StlModified#[+]" or ""
  local ro = bo.readonly and "%#StlModified#[󰌾]" or ""

  cache_buf.modified = mod .. ro
end

-- autocmd to update file info when open
api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = function(args)
		caching_file_info(args.buf);
		caching_git_info(args.buf)
		caching_modified(args.buf)
		update_all_statusline() -- make other window to inactive
	end,
})

-- autocmd to update file info for specific buffer when it is saved
api.nvim_create_autocmd("BufWritePost", {
	group = group,
	callback = function(args)
		caching_file_info(args.buf)
		caching_modified(args.buf)
		update_buf_statusline(args.buf)
	end,
})

-- autocmd to update modified info
api.nvim_create_autocmd({'TextChangedI', 'TextChanged'}, {
	group = group,
	callback = function(args)
		local old_modi = cache.bufs[args.buf] and cache.bufs[args.buf].modified
		caching_modified(args.buf) -- update modified
		if old_modi ~= cache.bufs[args.buf].modified then
			update_buf_statusline(args.buf)
		end
	end,
})

-- ==========================================
-- Set mode change
-- ==========================================

-- caching mode {mode, highlight_mode}
local modes = {
	-- Normal (StlModeNormal)
	["n"]      = { "NORMAL",  "Normal" },
	["no"]     = { "O-PEND",  "Normal" }, -- Operator-pending
	["nov"]    = { "O-PEND",  "Normal" },
	["noV"]    = { "O-PEND",  "Normal" },
	["no\22"]  = { "O-PEND",  "Normal" },
	["niI"]    = { "NORMAL",  "Normal" }, -- Insert pending Normal
	["niR"]    = { "NORMAL",  "Normal" },
	["niV"]    = { "NORMAL",  "Normal" },
	["nt"]     = { "NORMAL",  "Normal" }, -- Terminal-Normal

	-- Insert & Select (StlModeInsert)
	["i"]      = { "INSERT",  "Insert" },
	["ic"]     = { "I-COMP",  "Insert" },
	["ix"]     = { "I-COMP",  "Insert" },
	["s"]      = { "SELECT",  "Insert" },
	["S"]      = { "S-LINE",  "Insert" },
	["\19"]    = { "S-BLOCK", "Insert" }, -- Ctrl-S (Select Block)

	-- Visual (StlModeVisual)
	["v"]      = { "VISUAL",  "Visual" },
	["vs"]     = { "VISUAL",  "Visual" },
	["V"]      = { "V-LINE",  "Visual" },
	["Vs"]     = { "V-LINE",  "Visual" },
	["\22"]    = { "V-BLOCK", "Visual" }, -- Ctrl-V (Visual Block)
	["\22s"]   = { "V-BLOCK", "Visual" },

	-- Replace (StlModeReplace)
	["R"]      = { "REPLACE", "Replace" },
	["Rc"]     = { "REPLACE", "Replace" },
	["Rx"]     = { "REPLACE", "Replace" },
	["Rv"]     = { "V-REPL",  "Replace" }, -- Virtual Replace
	["Rvc"]    = { "V-REPL",  "Replace" },
	["Rvx"]    = { "V-REPL",  "Replace" },
	["r"]      = { "PROMPT",  "Replace" }, -- Hit-enter prompt

	-- Command & Terminal (StlModeCommand)
	["c"]      = { "COMMAND", "Command" },
	["cv"]     = { "VIM EX",  "Command" },
	["ce"]     = { "EX",      "Command" },
	["rm"]     = { "MORE",    "Command" },
	["r?"]     = { "CONFIRM", "Command" },
	["!"]      = { "SHELL",   "Command" },
	["t"]      = { "TERM",    "Command" }, -- Terminal-Job
}

-- autocmd to change mode of current window
api.nvim_create_autocmd("ModeChanged", {
	group    = group,
	callback = function()
		local m = modes[vim.v.event.new_mode] or { 'UNKNOWN', 'Normal' }
		cache.mode = "%#StlMode" .. m[2] .. "# " .. m[1] .. " %#StlMode" .. m[2] .. "Sep#"
		update_statusline(api.nvim_get_current_win())
	end,
})



-- ==========================================
-- Set Diagnostics
-- ==========================================

--- set diagnostic to cache
---@param buf integer
local function caching_diagnostics(buf)
	if not api.nvim_buf_is_valid(buf) then return end

	local counts = vim.diagnostic.count(buf)

	local err = counts[vim.diagnostic.severity.ERROR] or 0
	local warn = counts[vim.diagnostic.severity.WARN] or 0
	local info = counts[vim.diagnostic.severity.INFO] or 0
	local hint = counts[vim.diagnostic.severity.HINT] or 0

	local diag_str = ""
	if err > 0 then diag_str = diag_str .. string.format("%%#DiagnosticError#  %d ", err) end
	if warn > 0 then diag_str = diag_str .. string.format("%%#DiagnosticWarn#  %d ", warn) end
	if info > 0 then diag_str = diag_str .. string.format("%%#DiagnosticInfo#  %d ", info) end
	if hint > 0 then diag_str = diag_str .. string.format("%%#DiagnosticHint#  %d ", hint) end
	diag_str = (err > 0 and '%#DiagnosticError#  ' .. tostring(err) or "") ..
			   (warn > 0 and '%#DiagnosticWarn#  ' .. tostring(warn) or "") ..
			   (info > 0 and '%#DiagnosticInfo#  ' .. tostring(info) or "") ..
			   (hint > 0 and '%#DiagnosticHint#  ' .. tostring(hint) or "")
	local cache_buf = get_buf_cache(buf)
	cache_buf.diagnostics = diag_str
end

--- autocmd to update diagnostics info
api.nvim_create_autocmd("DiagnosticChanged", {
	group = group,
	callback = function(args)
		caching_diagnostics(args.buf)
		update_buf_statusline(args.buf)
	end
})

-- ==========================================
-- 💥 initialize at startup
-- ==========================================
vim.o.laststatus = 2
setup_highlights()
cache.mode = s_format("%%#StlModeNormal# NORMAL %%#StlModeNormalSep#")

-- set cache for already opened buffers and update statusline
for _, buf in ipairs(api.nvim_list_bufs()) do
	caching_file_info(buf)
end
update_all_statusline()
