local M = {}


-- ####################################################
-- * Common :
-- ####################################################

-- change separator on directory depends on OS
---@param path string relative path
---@param sep_to string? path separator after change
---@param sep_from string? path separator before change
---@param endslash boolean? add slash end of path or not
---@return string
M.sep_unify = function(path, sep_to, sep_from, endslash)
	local drive = path:match('^([a-zA-Z]):[\\/]')
	if drive then
		path = drive:upper() .. path:sub(2)
	end
	sep_to = sep_to or (vim.g.has_win32 and '\\' or '/')
	sep_from = sep_from or ((sep_to == '/') and '\\' or '/')
	local endchar = endslash and sep_to or ''
	local result = path:gsub('[/\\]+$', ''):gsub(sep_from, sep_to) .. endchar
	return result
end

-- get index of visualized word
---@return integer,integer,integer,integer
local GetIdxVisual = function ()
	-- caution: getpos("'>") or getpos("'<") is updated after end of visual mode
	-- so use getpos('v') or getpos('.')

	local start_pos = vim.fn.getpos('v') -- get position of start of visual box
	local end_pos   = vim.fn.getpos('.') -- get position of end of visual box
	local start_row, start_col = start_pos[2], start_pos[3]
	local end_row, end_col     = end_pos[2], end_pos[3]

	-- check end col regardless of non-ASCII char
	local lines = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)
	local end_bytecol = vim.str_utfindex(lines[1], 'utf-8', end_col)
	if end_bytecol then
		end_col = vim.str_byteindex(lines[1], 'utf-8', end_bytecol)
	else
		vim.notify('Error(AddStrong) : end_bytecol is nil', vim.log.levels.ERROR)
	end

	return start_row, start_col, end_row, end_col
end


-- check content is URL form like "https://*" or "www.*"
---@param content string web URL form
local IsUrl = function(content)
	return (string.match(content, '^(https?://)')
			or string.match(content,'^(www%.)'))
end


-- get link contents in []() format under cursor
---@return string|nil url it contains [..](..) form
local GetLink = function ()
	-- get link under current cursor
	local line = vim.api.nvim_get_current_line() -- get current line string
	local col = vim.fn.col('.') -- get current column under the cursor
	local start_idx, end_idx = 0, 0
	while true do
		-- get start/end index of []() pattern
		local s, e = string.find(line, '%b[]%b()', start_idx+1)

		-- if link doesn't exist
		if not s or not e then
			vim.notify('Link doese not exist under the cursor!', vim.log.levels.ERROR)
			return nil
		end
		start_idx = s
		end_idx = e

		-- if the pattern under cursor is caught
		if start_idx <= col and col <= end_idx then
			break
		end
	end
	local url = line:sub(start_idx, end_idx)
	return url
end


-- check extension of link is image file
---@param url string file name with extension
---@return boolean isValid true if the file is image
local IsImage = function (url)
	local image_ext_list = {'.bmp', '.jpg', '.jpeg', '.png', '.gif'}
	local ext = url:match('^.+(%..+)$')
	for _, val in ipairs(image_ext_list) do
		if ext == val then
			return true
		end
	end
	return false
end


-- check the url is absolute path
---@param url string file path
---@return boolean isValid true if the path is absolute path with drive character (for windows)
local IsAbsolutePath = function (url)
	local drive = string.find(url, '.:[\\/]')
	if not drive then
		return false
	end
	return true
end


--- Decode unicode from non-english word in url except white space
--- @param url string web URL form with encoding character from non-english word
--- @return string decoded_url The decoded URL from UTF-8 to korean
--- @return integer? hex The number of replacements made (optional).
local url_decode = function(url)
    return url:gsub("%%(%x%x)", function(hex)
		return hex:upper() == '20' and '%20' or string.char(tonumber(hex, 16))
    end)
end

--- Get image_flag / text / link from "![text](link)"
--- @param url string link pattern
--- @return table? Components of link url
local ResolveUrl = function (url)
	local c1, c2, c3 = string.match(url, "(!?)%[([^%]]*)%]%(([^)]*)%)")
	local link = {}

	-- insert items
	link.is_image = (c1 == "!")
	link.title = c2
	link.link = c3
	link.category = link.is_image and 'I' or (IsUrl(link.link) and 'W' or 'L') -- image(I), web(W), link(L)
	link.icon = (link.category == 'I') and '' or ( (link.category == 'W') and '󰖟' or '')

	if link.link then
		return link
	else
		return nil
	end
end

--- change slash direction in all paths
--- @param T string|table|any value is paths
--- @param from? string slash from
--- @param to? string slash to
--- @return table|string|any Changed paths
local SlashChange = function(T, from, to)
	local e_from = from or '/'
	local e_to = to or '\\'

	--- @param item table|string|any
	--- @return table|string|any
	local function process_item(item)
		if type(item) == 'table' then
			local result = {}
			for key, value in pairs(item) do
				result[key] = process_item(value) -- use recursive for multiple table
			end
			return result
		elseif type(item) == 'string' then
			-- vim.print({ item, e_from, e_to })
			local result_str, _ = string.gsub(item, e_from, e_to)
			return result_str
		else
			return item
		end
	end

	return process_item(T)
end
M.SlashChange = SlashChange


-- get root pattern of current file to check where is root directory
---@param bufnr integer buffer number
---@return string? root directory
local GetRoot = function (bufnr)
	---@return vim.lsp.Client[]
	local clients = vim.lsp.get_clients({bufnr = bufnr}) -- check lsp is attached
	local root
	if not vim.tbl_isempty(clients) then
		root = clients[1].config.root_dir
	else
		root = vim.fs.root(bufnr, {'.git'}) or vim.fn.expand('%:p:h')
	end

	return root
end
M.GetRoot = GetRoot

-- check buffer id
---@param bufnr number buffer id
---@return string? filename of bufnr
local function is_valid(bufnr)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	local buflisted = vim.fn.buflisted(bufnr) == 1
	if buflisted and (filepath ~= '') then
		return filepath
	end
	return nil
end

-- return listed buffer list
---@return number[]
local function get_valid_buflist()
	local valid_buflist = {}
	local buflist = vim.api.nvim_list_bufs()
	for _, bufid in ipairs(buflist) do
		if is_valid(bufid) then
			table.insert(valid_buflist, bufid)
		end
	end
	return valid_buflist
end

-- ####################################################
-- * System : Check process id from process name
-- ####################################################

-- get recent process id (windows only)
---@param processname string format is 'pyrefly.exe'. Extension must be needed
local function GetProcessId(processname)
	if not processname then
		return nil
	end

	-- get process list using cmd prompt (wmic is faster than pwsh)
	local command = {
		"wmic", "process", "where", "name=" .. '"' .. processname .. '"',
		"get", "CreationDate,ProcessId", "/format:csv"
	}
	local result = vim.system(command):wait()  -- stdout, stderr, ret
	if result.code ~= 0 then
		vim.print("wmic command failed:", result.stderr)
		return nil
	end

	-- split fields
	local processes = {}
	for line in result.stdout:gmatch("[^\r\n]+") do
		if not (line:match("^Node") or line:match("^$")) then -- ignore header / empty line
			-- CSV: Node,CreationDate,ProcessId
			local fields = vim.split(line, ',')
			if fields then
				table.insert(processes, {creation = fields[2], pid = fields[3]})
			end
		end
	end

	-- sort by creation time to check what is recent one
	table.sort(processes, function(a, b)
		return a.creation > b.creation
	end)

	return processes[1].pid
end
M.GetProcessId = GetProcessId

-- taskkill from pid (windows only)
local function TaskKill(pid)
	if not pid then
		return nil
	end

	local command = { "taskkill", "/PID", tostring(pid), '/F' }
	local result = vim.system(command):wait()  -- stdout, stderr, ret
	if result.code ~= 0 then
		return nil
	end
end
M.Taskkill = TaskKill

-- ####################################################
-- * Markdown : Follow image link with wezterm
-- ####################################################

-- string.find(s, "%b[]") find start and end index with matching [ and ]
-- string.find(s, "%b[]%b()") find pattern within [] followed by ()


-- follow image link
local FollowLink = function ()

	-- get only link pattern in full link
	local url = GetLink()
	if not url then
		return
	end
	url = string.match(url, '%[.-%]%((.-)%)') -- get words in ()

	-- if the url is not image, it is regarded as .md file or web link
	if not IsImage(url) then
		if IsUrl(url) then
			if vim.g.has_win32 then
				os.execute('start brave ' .. url) -- if url is web link, use brave web browser
			else
				os.execute('firefox ' .. '\'' ..  url .. '\'' .. ' > /dev/null 2>&1 &') -- if url is web link, use brave web browser
			end
		else
			-- vim.api.nvim_command(':Obsidian follow_link hsplit') -- if the link is file, open the link file in horizontal split view
			vim.lsp.buf.definition() -- open buffer using marksman lsp
		end
		return
	end

	-- check path is absolute
	-- caution: it assumes that Images are saved in subfolders of the current folder.
	local curdir = vim.fn.expand('%:p:h') -- get current buffer's dir
	local path = url
	path = path:gsub('/','\\') -- change for windows dir format
	path = string.gsub(path, '%%20',' ') -- decode white space
	if not IsAbsolutePath(url) then
		path = curdir .. '\\' .. path
	end

	-- check the terminal is wezterm (use wezterm for following image)
	if os.getenv('WEZTERM_PANE') ~= nil then
		vim.api.nvim_command('silent !wezterm cli split-pane --horizontal -- powershell wezterm imgcat ' .. '\'' ..  path .. '\'' .. ' ; pause')
	else
		os.execute('start "" "' .. path .. '"') -- use default open tool for windows
	end

end

M.FollowLink = FollowLink




-- ####################################################
-- * Markdown : ClipboardPaste
-- ####################################################

-- paste with different form from system clipboard
local ClipboardPaste = function ()

	-- check clipboard content
	-- '+' register has non empty contents when the system clipboard saves some character not image
	local clipboard_content = vim.fn.getreg('+')
	clipboard_content = url_decode(clipboard_content)

	-- Paste depends on format
	local markdown_link
	if IsUrl(clipboard_content) then -- if the link has web URL form, paste with link form

		-- if visual mode, get the visualized word and make it as link name
		local link_name = ''
		local mode = vim.fn.mode()
		if mode == 'v' or mode == 'V' then -- if current mode is visual mode ('v') or line mode ('V')

			local start_row, start_col, end_row, end_col = GetIdxVisual()
			local txt       = vim.api.nvim_buf_get_text(0, start_row-1, start_col-1, end_row-1, end_col, {})
			link_name       = table.concat(txt, '\n')
			markdown_link   = string.format('[%s](%s)',  link_name, clipboard_content)
			vim.api.nvim_buf_set_text(0, start_row-1, start_col-1, end_row-1, end_col, {markdown_link})
			vim.api.nvim_input('<Esc>') -- go out to normal mode

		else -- if normal mode, make link with empty link name
			markdown_link = string.format('[](%s)', clipboard_content)
			vim.api.nvim_put({markdown_link}, 'c', true, true)

		end

	elseif clipboard_content ~= '' then -- if the contents characters, paste from '+' register
		local termcodes = vim.api.nvim_replace_termcodes('"+p', true, false, true)
		vim.api.nvim_feedkeys(termcodes,'n', true)

	else -- if it is image, paste Image with obsidian function
		vim.api.nvim_command('Obsidian paste_img')
	end
end

M.ClipboardPaste = ClipboardPaste





-- ####################################################
-- * Markdown : open linked file in the floating window
-- ####################################################

local opened_windows = {}
local create_hover_window = function(filepath, anchor_match)
	filepath = filepath or vim.fn.expand('%:p')
	local filename = vim.fn.fnamemodify(filepath, ':t')
	local line = anchor_match and anchor_match.line or 1

	-- close previously opened windows
	for _, win in ipairs(opened_windows) do
		if vim.api.nvim_win_is_valid(win) then -- check this window handle is valid
			vim.api.nvim_win_close(win, true)  -- close the window with {force = true}
		end
	end
	opened_windows = {}

	-- set options of floating windows style
	local width = math.floor(vim.api.nvim_win_get_width(0) * 0.7)
	local height = math.max(30,1)
	local opts = {
		relative  = 'cursor',
		row       = 1,         -- start of x(right) index from cursor
		col       = 1,         -- start of y(below) index from cursor
		width     = width,     -- width of floating window
		height    = height,    -- height of floating window
		style     = 'minimal', -- it can be set by 'minimal' only
		anchor    = 'NW',      -- direction of window from cursor
		border    = 'rounded', -- single round corner
		title     = filename,  -- title in window border,
		title_pos = 'center',
	}

	-- create new buffer contains link contents
	local existing_buf = vim.fn.bufnr(filepath)
	local h_buf = existing_buf ~= -1 and existing_buf or vim.api.nvim_create_buf(false, false)
		-- nvim_create_buf()
		-- if [listed] is false, buffer title isn't displayed in buffer line (but I think it doesn't work)
		-- it means that the buffer isn't listed in buffer list
		-- if [scratch] is true, buftype is set to nofile which protects to write.

	vim.api.nvim_set_option_value('buflisted', false, {buf = h_buf})   -- don't display title
	vim.api.nvim_set_option_value('bufhidden', 'hide', {buf = h_buf})  -- hide (not delete) buffer if it is not displayed
                                                                       -- the buffer id is remained

                                                                       -- open floating window with buffer
	local current_hover_win = vim.api.nvim_open_win(h_buf, true, opts) -- open floating window and make it current window
	if existing_buf == -1 then
		vim.cmd('silent! edit ' .. vim.fn.fnameescape(filepath) )      -- open the buffer
	end
		-- If use vim.fn.readfile() and nvim_buf_set_lines() instead of 'edit', the loading time is fast.
		-- But it means that texts of the file is written in created buffer. so it needs name to save
		-- using nvim_buf_set_name. If the name is same with existing file, it invokes "already file exists" error.
		-- so I must use 'edit' to open existing file and save it. Created buffer has name automatically
		-- If I force to set name of the buffer in window, It invokes "already file exists" error also.
		-- 'edit' is more convenient to use because it has some features which is same with conventional buffer,
		-- such as detecting the filetype, modifiable, nowrap

	vim.api.nvim_set_option_value('signcolumn'    , 'no', {win = current_hover_win})
	vim.api.nvim_set_option_value('number'        , true, {win = current_hover_win})
	vim.api.nvim_set_option_value('relativenumber', true, {win = current_hover_win})
	vim.api.nvim_set_option_value('cursorline'    , true, {win = current_hover_win})
	vim.api.nvim_win_set_cursor(current_hover_win, {line, 0}) -- move the cursor to the specific line
	vim.cmd('normal! zt')                                     -- move screen to locate cursor to the top
	table.insert(opened_windows, current_hover_win)

	-- set default keymaps for floating buffer
	vim.keymap.set('n', 'q', function ()
		vim.cmd('write')
		vim.api.nvim_win_close(current_hover_win, true) -- close window forcely
		-- close window instead of buffer to remain the buffer hide
	end, {buffer = true, silent = true, desc = 'quit buffer'})

end

-- get the file contents under cursor
local GotoCursor = function()

	local url = GetLink()
	if not url then
		return
	end

	-- capture file name in ()
	local link_name = string.match(url, '%[.-%]%((.-)%)')
	if IsImage(link_name) or IsUrl(link_name) then
		vim.notify('Error(GotoCursor) : It is not file link', vim.log.levels.ERROR)
		return
	end

	-- separate path and tag with #
	local path, tag = require('obsidian.util').strip_anchor_links(link_name)
	if not path then
		vim.notify('Error(GotoCursor) : It is not file path', vim.log.levels.ERROR)
		return
	end

	-- get top level workspace
	local obs = require('obsidian')
	local obs_note = require('obsidian.note')

	local client = obs.get_client() -- Get client of current note
	local vault = client.dir.filename

	-- find absolute path of the file
	if path == "" then -- get location of current buffer
		path = client.buf_dir.filename .. '/' .. vim.fn.expand('%')
	else
		if not IsAbsolutePath(path) then
			path = vault .. '/' .. path
		end
	end

	if vim.g.has_win32 then
		path = path:gsub('/', '\\')
	end

	-- check the path is in workspaces
	-- local ok = obs_workspace.get_workspace_for_dir(path, client.opts.workspaces)
	local ok = vim.fn.filereadable(path) -- check the file is existed
	if ok == 1 then
		-- get tag's location
		local note = obs_note.from_file(path)
		local anchor_match
		if tag ~= nil then
			anchor_match = note:resolve_anchor_link(tag)
		end

		-- open the buffer in floating window
		create_hover_window(path, anchor_match)
	else
		vim.notify('Error(GotoCursor) : Cannot find this file link', vim.log.levels.ERROR)
	end

end

M.GotoCursor = GotoCursor



-- ####################################################
-- * Markdown : Add Strong mark
-- ####################################################


-- Add strong mark (**) both side of visualized region
---@param args string marks to add before and after visualized word (default is **)
local AddStrong = function (args)
	-- get index of visualized word
	local start_row, start_col, end_row, end_col = GetIdxVisual()
	vim.print({end_row, end_col})

	if type(args) ~= 'string' then
		vim.notify('Error(AddStrong) : use string for args', vim.log.levels.ERROR)
		return
	end

	local marks = args or '**' -- set marks to add
	local marks_e = marks
	local tag = marks:match('^<([^>]+)>$')
	if tag then
		marks_e = '</' .. tag .. '>'
	end

	-- Add asterisks at the start of the selection
	vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, start_row - 1, start_col - 1, {marks})

	-- check end col regardless of non-ASCII char
	local lines = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)
	if start_row == end_row then -- if 'marks' is added in same line, it is included in end_col calculation
		end_col = end_col + #marks
	end

	local end_bytecol = vim.str_utfindex(lines[1], 'utf-8', end_col)
	if end_bytecol then
		end_col = vim.str_byteindex(lines[1], 'utf-8', end_bytecol) + 1 -- move cursor to next of word
	else
		vim.notify('Error(AddStrong) : end_bytecol is nil', vim.log.levels.ERROR)
		return
	end

	-- Add asterisks at the end of the selection
	vim.api.nvim_buf_set_text(0, end_row - 1, end_col - 1 , end_row - 1, end_col - 1, {marks_e})

	-- go to normal mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

M.AddStrong = AddStrong



-- ####################################################
-- * Markdown : Get list of header
-- ####################################################

--- Get root, query treesitter of current buffer from parsing pattern
--- @param bufid number buffer id
--- @param ft_parsing string parser name
--- @param pattern string parsing pattern
--- @return TSNode? Root object of treesitter tree
--- @return vim.treesitter.Query? Query object of treesitter tree
local GetPattern = function (bufid, ft_parsing, pattern)
	-- local ft = vim.api.nvim_get_option_value('filetype', {buf = bufid})
	-- if ft ~= 'markdown' then
	-- 	vim.notify(' Please execute this function in markdown ', vim.log.levels.ERROR)
	-- 	return nil, nil
	-- end

	ft_parsing = ft_parsing or vim.bo.filetype
	local parser = vim.treesitter.get_parser(bufid, ft_parsing)
	if not parser then
		vim.notify(' No Treesitter parser found for the filetype : ' .. ft_parsing, vim.log.levels.ERROR)
		return nil, nil
	end

	local tree = parser:parse()[1]
	if not tree then
		vim.notify(' No Treesitter tree found for this buffer : ' .. ft_parsing, vim.log.levels.ERROR)
		return nil, nil
	end

	local root = tree:root()
	if not pattern then
		return root, nil
	end

	local query = vim.treesitter.query.parse(ft_parsing, pattern)
	if not query then
		vim.notify(' Error parsing treesitter query ', vim.log.levels.ERROR)
		return nil, nil
	end

	return root, query
end
M.GetPattern = GetPattern

--- Get items from parser to use snacks picker list
--- @param min_level number minimal level of header to be shown in snacks picker
--- @return table? items to show in snacks picker
local Get_Headers = function(min_level)
	local minlevel = min_level or 6

	-- check buffer
	local cur_bufid = vim.api.nvim_get_current_buf()
	local pattern = '(atx_heading) @header'
	local root, query = GetPattern(cur_bufid, 'markdown', pattern)
	if not root or not query then
		return
	end

	local headers = {}
	local matches = query:iter_captures(root, cur_bufid, 0, -1)
	for _, node, _, _ in matches do
		local row, col = node:start()  -- line number of header
		local text = vim.treesitter.get_node_text(node, 0) -- get text of captured node
		local child = node:child(0) -- get first child
		local child_type
		if child then
			child_type = child:type()
		else
			vim.notify('child is nil')
			return
		end

		if child_type:sub(1, 5) == 'atx_h' then
			local level = tonumber(child_type:sub(6, 6))
			local heading = string.gsub(text:sub(level+1), "^%s+", "")

			if level <= minlevel then
				table.insert(headers, {
					data = {
						level = "H" .. level,
						heading = heading,
					},
					text = "H" .. level .. " " .. heading, -- it is used for searching only
					file = vim.api.nvim_buf_get_name(cur_bufid),
					pos = {row + 1, col + 1}, -- cursor location, it can be used in preview
				})
			end
		end
	end

	if #headers == 0 then
		vim.notify('No headers found at level ' .. min_level .. ' or higher.', vim.log.levels.INFO)
		return
	end

	return headers
end

--- Show headers using snacks picker
--- @param min_level number minimal level of header to be shown in snacks picker
local Show_Headers = function (min_level)
	-- check snacks is loaded
	local snacks_ok, snacks = pcall(require, 'snacks')
	if not snacks_ok then
		vim.notify('snacks.nvim is not installed', vim.log.levels.ERROR)
		return
	end

	snacks.picker.pick({
		finder = function ()
			local items = Get_Headers(min_level)
			if items then
				return items
			end
			return {}
		end,
		format = function (item, picker)
			local a = snacks.picker.util.align -- for setting strict width
			local ret = {}
			ret[#ret +1] = {a(item.data.level, 4), 'SnacksPickerGitCommit'}
			ret[#ret +1] = {item.data.heading}
			snacks.picker.highlight.markdown(ret) -- set highlight for other text
			return ret
		end,
		preview = 'file',
		confirm = function (picker, item)
			picker:close()
			if item then
				vim.api.nvim_win_set_cursor(0, {item.pos[1], item.pos[2]}) -- go to cursor
				vim.cmd("normal! zt")
			end
		end,

	})
end
M.Show_Headers = Show_Headers


-- ####################################################
-- * Markdown : Get link list
-- ####################################################
local Get_Linklist = function()

	-- check buffer
	local cur_bufid = vim.api.nvim_get_current_buf()
	local pattern = [[
		(image) @link_node
		(inline_link) @link_node
	]]
	-- local pattern = '(inline_link) @link_node'
	local root, query = GetPattern(cur_bufid, 'markdown_inline', pattern)
	if not root or not query then
		return
	end

	local items = {}
	local maxlen = 0
	local matches = query:iter_captures(root, cur_bufid, 0, -1)
	for _, node, _, _ in matches do
		local row, col = node:start()  -- line number of header
		local text = vim.treesitter.get_node_text(node, 0) -- get text of captured node
		local link = ResolveUrl(text)
		if not link then
			vim.notify('No links found' , vim.log.levels.INFO)
			return
		end

		-- find max title length
		if #link.title > maxlen then
			maxlen = #link.title
		end

		table.insert(items, {
			data = link,
			text = link.category .. ' ' .. link.title .. ' ' .. link.link,
			file = vim.api.nvim_buf_get_name(cur_bufid),
			pos = {row + 1, col + 1},
		})
	end

	-- insert max_title length
	for _, item in ipairs(items) do
		item.data.maxlen = maxlen
	end

	if #items == 0 then
		vim.notify('No items found' , vim.log.levels.INFO)
		return
	end

	return items
end
M.Get_Linklist = Get_Linklist

--- Show all links in current buffer
local Show_Linklist = function ()
	-- check snacks is loaded
	local snacks_ok, snacks = pcall(require, 'snacks')
	if not snacks_ok then
		vim.notify('snacks.nvim is not installed', vim.log.levels.ERROR)
		return
	end

	snacks.picker.pick({
		finder = function ()
			local items = Get_Linklist()
			if items then
				return items
			end
			return {}
		end,
		format = function (item, picker)
			local a = snacks.picker.util.align -- for setting strict width
			local ret = {}
			local row_highlight = item.data.category == "I" and 'SnacksPickerCode' or (
								  item.data.category == "W" and 'MarkviewHyperlink' or (
								  item.data.category == 'L' and 'MarkviewEmail' or nil))
			ret[#ret +1] = {a(item.data.icon, 2), row_highlight}
			ret[#ret +1] = {a(item.data.category, 2), row_highlight}
			ret[#ret +1] = {a(item.data.title, item.data.maxlen + 2), row_highlight}
			ret[#ret +1] = {item.data.link}
			snacks.picker.highlight.markdown(ret) -- set highlight for other text
			return ret
		end,
		preview = 'file',
		confirm = function (picker, item)
			picker:close()
			if item then
				vim.api.nvim_win_set_cursor(0, {item.pos[1], item.pos[2]}) -- go to cursor
				vim.cmd("normal! zt")
			end
		end,

	})
end
M.Show_Linklist = Show_Linklist


-- ####################################################
-- * Markdown : callout snippet
-- ####################################################

local CalloutSnippet = function ()
	local callouts = {
		'NOTE',
		'ABSTRACT',
		'SUMMARY',
		'CHECK',
		'IMPORTANT',
		'EXAMPLE',
		'QUESTION',
		'ANSWER',
		'FAQ',
		'HELP',
		'QUOTE',
		'CITE',
		'TIP',
		'HINT',
		'INFO',
		'TODO',
		'CAUTION',
		'WARNING',
		'DANGER',
		'MISSING',
	}

	vim.ui.select(callouts, {
		prompt = 'Select callouts:',
		format_item = function (item)
			return item
		end
	}, function (choice)
		if choice then
			local line1 = "> [!" .. choice .. "]"
			local line2 = "> "
			vim.api.nvim_put({line1, line2}, 'c', true, true)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('a', true, false, true), 'n', false)
		end
	end)
end
M.CalloutSnippet = CalloutSnippet


-- ####################################################
-- * keymap : smart folding
-- ####################################################

-- check current node under cursor is target_node
---@param targets string|table target node to check this region under cursor is the node
--- @return TSNode? Object of treesitter tree
local function is_node(targets)
	if type(targets) == 'string' then
		targets = { targets }
	end
	-- get treesitter root
	local root = require('jaehak.core.utils').GetPattern(0)
	if not root then
		return nil
	end

	-- get super parent node at cursor position
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local node = root:named_descendant_for_range(row, col, row, col)
	while node do
		local t = node:type()
		for _, target in ipairs(targets) do
			if t == target then
				return node
			end
		end
		node = node:parent()
	end

	return nil
end
-- M.is_node = is_node

-- smart fold
-- if the node is comment|string under cursor, fold the reigon
local function smart_fold()
	local foldlevel = vim.fn.foldlevel('.')
	if foldlevel == 1 then
		vim.cmd('normal! za') -- toggle fold if there are fold
	elseif foldlevel > 1 then
		vim.cmd('normal! zv') -- open fold recursive until show the line
	else
		local mode = vim.fn.mode()
		if mode == 'v' or mode == 'V' then -- if current mode is visual mode ('v') or line mode ('V')
			vim.cmd('normal! zf')
		else
			local node = is_node({'comment', 'string'})
			if node then
				local start_row, _, end_row, _ = node:range()

				-- detect proximity same type node
				local prev_node = node:prev_named_sibling()
				local next_node = node:next_named_sibling()

				-- find consecutively adjacent previous nodes (don't detect node which separated with new line)
				while prev_node and prev_node:type() == node:type() do
					local prev_start_row, _, prev_end_row, _ = prev_node:range()
					if prev_end_row + 1 == start_row then
						start_row = prev_start_row
						prev_node = prev_node:prev_named_sibling()
					else
						break
					end
				end

				-- find consecutively adjacent next nodes (don't detect node which separated with new line)
				while next_node and next_node:type() == node:type() do
					local next_start_row, _, next_end_row, _ = next_node:range()
					if next_start_row == end_row + 1 then
						end_row = next_end_row
						next_node = next_node:next_named_sibling()
					else
						break
					end
				end

				vim.api.nvim_win_set_cursor(0, {start_row + 1, 0})
				vim.cmd('normal! V')
				vim.api.nvim_win_set_cursor(0, {end_row + 1, 0})
				vim.cmd('normal! zf')
			end
		end
	end

end
M.smart_fold = smart_fold


-- ####################################################
-- * keymap : run
-- ####################################################

---@param file string|nil absolute path of file which runs
local function run(file)
	file = file or vim.api.nvim_buf_get_name(0)

	-- check unsaved file
	if file == '' then
		vim.notify('It needs to save file', vim.log.levels.ERROR)
		return
	end

	-- check runner by filetype
	local extension = vim.fn.fnamemodify(file, ':t:e')
	local cmd = nil
	if vim.tbl_contains({'py'}, extension) then
		cmd = 'python'
	elseif vim.tbl_contains({'lua'}, extension) then
		if vim.fs.root(0, 'nvim') then
			vim.cmd('luafile %')
			return
		else
			cmd = 'lua'
		end
	elseif vim.tbl_contains({'ps1'}, extension) then
		cmd = 'pwsh'
	end

	if cmd then
		vim.fn.jobstart({ cmd, vim.fn.fnameescape(file) },{
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function (_, data, _)
				vim.notify(table.concat(data, "\n"), vim.log.levels.TRACE)
			end,
			on_stderr = function (_, data, _)
				vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
			end,
		})
	end
end
M.run = run



-- ####################################################
-- * keymap : scrollbind
-- ####################################################

M.toggle_scrollbind = function ()
	local is_active = vim.api.nvim_get_option_value('scrollbind', {win = 0})
	is_active = not is_active

	local win_list = vim.api.nvim_tabpage_list_wins(0)
	for _, wid in ipairs(win_list) do
		vim.api.nvim_set_option_value('scrollbind', is_active, {win = wid})
	end
end


-- ####################################################
-- * oldfiles
-- ####################################################

-- ignore patterns
local oldfile_ignored = {
	'^oil://',
	'doc/',
	'health://',
}
local listed_buffer_hash = {}
local duplicated_buffer_hash = {}

---@param path string filepath from oldfiles
---@return boolean true if ignored
local function is_oldfile_ignored(path)
	-- check this file is readable
	if vim.fn.filereadable(path) == 0 then
		return true
	end
	-- check ignore pattern
	for _, pattern in ipairs(oldfile_ignored) do
		if string.match(path, pattern) then
			return true
		end
	end
	-- check this buffer is listed
	-- check this buffer is duplicated (sometimes oldfiles output duplicated list)
	if listed_buffer_hash[path] or duplicated_buffer_hash[path] then
		return true
	end
	return false
end

---@class oldfiles.item
---@field text string
---@field file string
---@field pos table<number, number>
---@field filename string
---@field dirname string

-- get oldfiles items for snacks picker
---@return oldfiles.item
local function get_oldfiles()
	local oldfiles = vim.v.oldfiles
	local len_oldfiles = #oldfiles

	-- add hash to buffer
	listed_buffer_hash = {}
	duplicated_buffer_hash = {}
	local valid_buflist = get_valid_buflist()
	for _, bufnr in ipairs(valid_buflist) do
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		filepath = M.sep_unify(filepath, '/')
		listed_buffer_hash[filepath] = true
	end

	local items = {}
	for i, file in ipairs(oldfiles) do
		file = M.sep_unify(file, '/')
		local filename = vim.fn.fnamemodify(file, ':t')
		local dirname = vim.fn.fnamemodify(file, ':~:h')
		dirname = M.sep_unify(dirname, '/', nil, true) -- unify slash

		if not is_oldfile_ignored(file) then
			table.insert(items, {
				text     = filename .. ' ' .. dirname,
				file     = file,
				pos      = {1,1},
				filename = filename, -- manual
				diralias = dirname, -- manual
				score    = len_oldfiles - i, -- remain order of vim.v.oldfiles
			})
			duplicated_buffer_hash[file] = true
		end
	end
	return items
end

-- oldfile picker
M.oldfile_picker = function ()
	-- check snacks is loaded
	local snacks_ok, snacks = pcall(require, 'snacks')
	if not snacks_ok then
		vim.notify('snacks.nvim is not installed', vim.log.levels.ERROR)
		return
	end

	local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
	if not devicons_ok then
		vim.notify('nvim-web-devicons is not installed', vim.log.levels.ERROR)
		return
	end

	snacks.picker.pick({
		items = get_oldfiles(),
		format = function (item, _)
			local ret = {}
			local icon, icon_hl = devicons.get_icon(item.filename, nil, {default = true})
			local a = snacks.picker.util.align -- for setting strict width

			ret[#ret +1] = {a(icon,2), icon_hl}
			ret[#ret +1] = {item.filename}
			ret[#ret +1] = {' '}
			ret[#ret +1] = {item.diralias, 'SnacksPickerDir'}
			return ret
		end,
		preview = 'file',
		transform = function (item,_ )
			-- set order of list
			item.score_add = item.score

			-- truncate directory if they are too long
			local len_text = #item.text + 2 -- with icon
			local max_len = vim.o.columns * 0.9
			if len_text > max_len then
				local diralias = item.diralias
				local displayed = ':' .. item.filename .. ' ' .. diralias
				while #displayed > max_len do
					local slash_pos = diralias:find('/')
					if not slash_pos then
						break
					end
					diralias = diralias:sub(slash_pos + 1)
					displayed = '   ' .. item.filename .. ' :' .. diralias
				end
				item.diralias = ':' .. diralias
			end
			return item
		end,
		confirm = function (picker, item)
			picker:close()
			if item then
				vim.cmd('edit ' .. item.file )
			end
		end,
		layout = {
			preset = 'vertical',
			layout = {
				width = 0.9,
			}
		}
	})
end


return M
