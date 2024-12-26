local M = {}


-- ####################################################
-- * Common :
-- ####################################################

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
	local end_bytecol = vim.str_utfindex(lines[1], end_col)
	if end_bytecol then
		end_col = vim.str_byteindex(lines[1], end_bytecol)
	else
		vim.api.nvim_err_writeln('Error(AddStrong) : end_bytecol is nil')
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
			vim.api.nvim_err_writeln('Link doese not exist under the cursor!')
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
	local drive = string.find(url, '.:\\')
	if not drive then
		return false
	end
	return true
end


--- Decode unicode from non-english word in url
--- @param url string web URL form with encoding character from non-english word
--- @return string decoded_url The decoded URL from UTF-8 to korean
--- @return integer? hex The number of replacements made (optional).
local url_decode = function(url)
    return url:gsub("%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end)
end



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
			os.execute('start brave ' .. url) -- if url is web link, use brave web browser
		else
			vim.api.nvim_command(':ObsidianFollowLink hsplit') -- if the link is file, open the link file in horizontal split view
		end
		return
	end

	-- check path is absolute
	-- caution: it assumes that Images are saved in subfolders of the current folder.
	local curdir = vim.fn.expand('%:p:h') -- get current buffer's dir
	local path = url
	path = path:gsub('/','\\') -- change for windows dir format
	if not IsAbsolutePath(url) then
		path = curdir .. '\\' .. path
	end

	-- check the terminal is wezterm (use wezterm for following image)
	if os.getenv('WEZTERM_PANE') ~= nil then
		vim.api.nvim_command('silent !wezterm cli split-pane --horizontal -- powershell wezterm imgcat ' .. '\'' ..  path .. '\'' .. ' ; pause')
	else
		os.execute('start ' .. path) -- use default open tool for windows
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
		vim.api.nvim_command('ObsidianPasteImg')
	end
end

M.ClipboardPaste = ClipboardPaste





-- ####################################################
-- * Markdown : open linked file in the floating window
-- ####################################################

local opened_windows = {}
local create_hover_window = function(filepath, filetype)

	local filename = vim.fn.fnamemodify(filepath, ':t')

	-- close previously opened windows
	for _, win in ipairs(opened_windows) do
		if vim.api.nvim_win_is_valid(win) then -- check this window handle is valid
			vim.api.nvim_win_close(win, true) -- close the window with {force = true}
		end
	end
	opened_windows = {}

	-- create new buffer contains link contents
	local h_buf = vim.api.nvim_create_buf(false, true)

	-- set options of floating windows style
	local width = math.floor(vim.api.nvim_win_get_width(0) * 0.5)
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

	-- open floating window with buffer
	local current_hover_win = vim.api.nvim_open_win(h_buf, false, opts)
	vim.api.nvim_set_option_value('wrap', false, {win = current_hover_win})
	table.insert(opened_windows, current_hover_win)

	-- move focus to floating window
	vim.api.nvim_set_current_win(current_hover_win)
	vim.cmd('edit ' .. vim.fn.fnameescape(filepath) ) -- open the buffer
	vim.api.nvim_set_option_value('filetype', 'Floating', {buf = h_buf})
	vim.api.nvim_set_option_value('modifiable', true, {buf = h_buf})

	-- set default keymaps for floating buffer
	vim.keymap.set('n', 'q', ':wq!<CR>', {buffer = true, silent = true, desc = 'quit buffer'})
end

-- get the file contents under cursor
local GotoCursor = function()

	local url = GetLink()
	if not url then
		return
	end

	local link_name = string.match(url, '%[.-%]%((.-)%)') 		-- capture file name in ()
	if IsImage(link_name) or IsUrl(link_name) then
		vim.api.nvim_err_writeln('Error(GotoCursor) : It is not file link')
		return
	end

	local path, tag = string.match(link_name, '([^#]*)#?(.*)') 	-- separate path and tag with #
	if not path then
		vim.api.nvim_err_writeln('Error(GotoCursor) : It is not file path')
		return
	end

	-- get top level workspace
	local obs = require('obsidian')
	local obs_workspace = require('obsidian.workspace')

	local cur_dir = vim.fn.expand('%:p:h')
	local workspaces = obs.get_client().opts.workspaces
	local workspace = obs_workspace.get_workspace_for_dir(cur_dir, workspaces).path.filename
	path = workspace .. '\\' .. path -- get absolute path of file
	path = path:gsub('/','\\') -- change to windows path form

	-- vim.print(path)
	create_hover_window(path)

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
		vim.api.nvim_err_writeln('Error(AddStrong) : use string for args')
		return
	end
	local marks = args or '**' -- set marks to add

	-- Add asterisks at the start of the selection
	vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, start_row - 1, start_col - 1, {marks})

	-- check end col regardless of non-ASCII char
	local lines = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)
	if start_row == end_row then -- if 'marks' is added in same line, it is included in end_col calculation
		end_col = end_col + #marks
	end

	local end_bytecol = vim.str_utfindex(lines[1], end_col)
	if end_bytecol then
		end_col = vim.str_byteindex(lines[1], end_bytecol) + 1 -- move cursor to next of word
	else
		vim.api.nvim_err_writeln('Error(AddStrong) : end_bytecol is nil')
		return
	end

	-- Add asterisks at the end of the selection
	vim.api.nvim_buf_set_text(0, end_row - 1, end_col - 1 , end_row - 1, end_col - 1, {marks})

	-- go to normal mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

M.AddStrong = AddStrong





return M
