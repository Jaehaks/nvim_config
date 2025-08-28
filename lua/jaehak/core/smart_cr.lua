local M = {}

-- Create an indented white spaces, if 8, 8 spaces if expandtab, or 2 tabs if notexpandtab with 4 shift-width
---@param level integer the number of spaces to set indent before text
local function create_indent(level)
	local indent_char = vim.bo.expandtab and ' ' or '\t'
	local indent_size = vim.bo.expandtab and level or level/vim.bo.shiftwidth
	return string.rep(indent_char, indent_size)
end


-- Check if the current cursor position is within the parentheses
local bracket_pairs = {
	['('] = ')',
	['['] = ']',
	['{'] = '}',
	['<'] = '>',
}
---@return boolean Whether cursor is in brackets
local function is_cursor_in_brackets()
	local text = vim.api.nvim_get_current_line()  -- all text that includes '\t' or ' ' indent of current line
	local col = vim.api.nvim_win_get_cursor(0)[2] -- (row, col-1) index

	-- Check the characters before and after the cursor
	local before = text:sub(1, col)      -- get string before cursor
	local after = text:sub(col+1, #text) -- get string after cursor

	-- get bracket pattern to match
	local open_pattern = ''
	local close_pattern = ''
	for open, close in pairs(bracket_pairs) do
		open_pattern = open_pattern .. vim.pesc(open)
		close_pattern = close_pattern .. vim.pesc(close)
	end
	open_pattern = '([' .. open_pattern .. '])'
	close_pattern = '([' .. close_pattern .. '])'

	local before_bracket = before:match('.*' .. open_pattern) -- matched before bracket which is closed to cursor
	local after_bracket = after:match(close_pattern) -- matched after bracket which is closed to cursor

	-- Check open and closed parentheses pairs
	if before_bracket and after_bracket and after_bracket == bracket_pairs[before_bracket] then
		return true
	end

	return false
end

--[[
	make bracket
	before => a = {|}
	after  => a = {
				  |
			  }
--]]
-- Enter key post-processing
---@param prev_line integer line number of previous line which is under cursor
local function post_enter(prev_line)

	local prev_indent_count = vim.fn.indent(prev_line)
	local prev_indent = create_indent(prev_indent_count)
	local cur_indent_count = prev_indent_count + vim.bo.shiftwidth
	local cur_indent = create_indent(cur_indent_count)

	local text = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local after = text:sub(col+1) -- get string after cursor


	-- make close_bracket with new indented line
	-- it would ignore any indentexpr process of ftplugin
	vim.api.nvim_buf_set_lines(0, prev_line, prev_line+1, false, {
		cur_indent,
		prev_indent .. after,
	}) -- set 2 line contents to one line range (start, start+1) => insert these line contents
	vim.api.nvim_win_set_cursor(0, {prev_line+1, cur_indent_count+1})
end

-- smart enter
function M.smart_enter()
	local prev_line = vim.api.nvim_win_get_cursor(0)[1]

	-- normal <CR>
	local key = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
	vim.api.nvim_feedkeys(key, "n", false)

	if is_cursor_in_brackets() then
		-- execute post_enter() after 1ms delay.
		-- nvim_feedkeys() is executed asynchronously so post_enter() is executed before cursor is moved
		vim.defer_fn(function()
			post_enter(prev_line)
		end,1)
	end
end




return M
