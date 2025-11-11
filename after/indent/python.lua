-- default is 'tcqj',
-- To add comment sign '#' automatically when I press enter, change this.
vim.opt_local.formatoptions = 'jcroql'

local config = {
	closed_paren_align_last_line  = true,
	open_paren                    = vim.bo.shiftwidth,
	nested_paren                  = vim.bo.shiftwidth,
	continue                      = vim.bo.shiftwidth,
	searchpair_timeout            = 150, -- [ms]
	disable_parentheses_indenting = false,
}

local debug = false

local function debugprint(str)
	if debug then
		vim.print(str)
	end
end

-- Check current line is belonging to treesitter patterns
---@param lnum integer
---@param col integer
---@param patterns string|string[]
---@return boolean true if current cursor is in patterns node
local function node_matches(lnum, col, patterns)
	lnum = lnum-1
	col = col-1
	local bufnr = vim.api.nvim_get_current_buf()

	if type(patterns) == 'string' then
		patterns = {patterns}
	end

	local captures = vim.treesitter.get_captures_at_pos(bufnr, lnum, col)
	for _, data in ipairs(captures or {}) do
		local node_name = data.capture
		if vim.tbl_contains(patterns, node_name) then
			return true
		end
	end
	return false
end


local maxoff = 50 -- range to search
-- search open parentheses which is the most closed from current line number
---@param lnum integer
---@param flags string
---@return [integer, integer] [line, col]
local function search_bracket(lnum, flags)
	return vim.fn.searchpairpos('[[({]', '', '[])}]',
								flags,
								-- when find parens, ignore parentheses in comment/string/todo
								-- it iterate from current cursor to maxoff. so the skip argument is based to every detecting line
								-- line() and col() must use to calculate.
								function() return node_matches(vim.fn.line('.'), vim.fn.col('.'), {'comment', 'string', 'todo'}) end,
								math.max(0, lnum - maxoff),
								config.searchpair_timeout)
end

-- check lnum indent is dedented from expected indent
---@param lnum integer
---@param expected integer
---@return boolean
local function dedented(lnum, expected)
	return vim.fn.indent(lnum) <= expected - vim.bo.shiftwidth
end

-- get valid string which is not belong to comment region.
---@param lnum number line number
---@return string
local function get_validstr(lnum)
	local line = vim.fn.getline(lnum)
	local min, max = 1, #line
	while min < max do
		local col = math.floor((min + max) / 2)
		if node_matches(lnum, col, {'comment', 'todo'}) then
			max = col
		else
			min = col + 1
		end
	end
	return line:sub(1, min - 1)
end

-- Main indent function
_G.python_indent_user = function(lnum, extra_func)
	local ExtraFunc = extra_func or nil
	local line = vim.fn.getline(lnum) -- get contents of line
	local prev_lnum = vim.fn.prevnonblank(lnum - 1) -- get line number which has non-blank contents above lnum

	-- INFO: Top of documents
	-- if lnum is top line, indent is 0
	if prev_lnum == 0 then return 0 end

	-- if prev line is not empty, get the contents and indentation info
	local prev_line = vim.fn.getline(prev_lnum)
	local prev_indent = vim.fn.indent(prev_lnum)
	local cur_indent = vim.fn.indent(lnum)

	-- INFO: Backslash continuation
	-- multiple line command is end with '\', it check prev line is end with '\'
	if prev_line:match('\\$') then
		if prev_lnum > 1 and vim.fn.getline(prev_lnum - 1):match('\\$') then
			debugprint('line-91: ' .. tostring(prev_indent))
			return prev_indent -- use prev indent if the multiple line is over than 2 lines.
		end
		debugprint('line-94: ' .. tostring(prev_indent + config.continue))
		return prev_indent + config.continue -- if current is seconds line, use config.continue
	end

	-- INFO: String start
	-- if start of line is in a string, remain the indent
	if vim.fn.has('syntax_items') == 1 and node_matches(lnum, 1, 'string') then
		debugprint('line-101: ' .. tostring(-1))
		return -1
	end


	-- INFO: Parentheses handling
	local plnum = prev_lnum -- get line number which has non-blank contents above lnum
	local plnumstart -- reference line number, if cursor is in parentheses, it is line number of open paren
					 -- if cursor is out of parentheses, it means line number of prev_line
	local plindent -- indent of plumstart
	local parlnum, parcol = 0, 0
	if config.disable_parentheses_indenting then
		-- if disable, It follows indent of previous line
		plnumstart = plnum
		plindent = prev_indent
	else
		vim.fn.cursor(lnum, 1) -- move cursor location
		parlnum, parcol = unpack(search_bracket(lnum, 'nbW')) -- get open parentheses (lnum, colnum)
		local parlnum_indent = vim.fn.indent(parlnum)
		if parlnum > 0 then
			-- INFO: if open paren is not on end of line.
			-- my_function(args,|
			-- 			   args2)
			-- args2 is placed below open '('
			-- local end_col = vim.fn.col({parlnum, '$'}) - 1 -- get column of end of line. (It has bug when comment is relied next to paren )
			local valid_line = vim.fn.trim(get_validstr(parlnum)) -- get line contents except of comment region
			local end_col = parlnum_indent + #valid_line
			if parcol ~= end_col then
				debugprint('line-127: ' .. tostring(end_col))
				debugprint('line-127: ' .. tostring(parcol))
				return parcol
			-- INFO: if open paren is on end of line.
			-- my_list = [|
			--     item1,
			-- ]  indent of closed paren ])} is same with start of line where open paren is.
			elseif line:match('^%s*[%]%)}]') and not config.closed_paren_align_last_line then
				debugprint('line-135: ' .. tostring(parlnum))
				return parlnum_indent
			end
		end

		-- INFO: Previous line is in parentheses
		-- my_list = [   -- parlnum
		-- 		test,|   -- prev_lnum
		-- 		test2,
		-- ]
		-- cursor is in parentheses, the indent is followed the one of previous line
		vim.fn.cursor(prev_lnum, 1)
		parlnum, parcol = unpack(search_bracket(plnum, 'nbW')) -- search paren including current line
		if parlnum > 0 then
			if ExtraFunc and ExtraFunc(parlnum) then -- if bitbake, indent is ignored
				parlnum, plindent, plnumstart = 0, prev_indent, plnum
			else -- previous line is inside of parentheses
				plindent, plnumstart = vim.fn.indent(parlnum), parlnum
			end
		else -- previous line is out of parentheses
			plindent, plnumstart = prev_indent, plnum
		end

		-- Current line in parens (first line below opening)
		vim.fn.cursor(lnum, 1)
		local p = search_bracket(lnum, 'bW')[1] -- search paren excluding current line
		-- p = line number of open paren which is closed from current line, if not, 0
		if p > 0 then -- current cursor is in parentheses, (opened bracket is detected above current line )
			if ExtraFunc and ExtraFunc(p) then -- if it is bitbake block
				-- INFO: it is start of bitbake, insert with shiftwidth
				if p == plnum then
					debugprint('line-165: ' .. tostring(p))
					debugprint('line-165: ' .. tostring(plnum))
					return vim.bo.shiftwidth
				end
				-- INFO: it is end of bitbake, dedent with shiftwidth
				if line:match('^%s*%}') then
					debugprint('line-171: ' .. tostring(-2))
					return -2 -- dedent with vim.bo.shiftwidth
				end
				-- INFO: otherwise, ignore the brace
				p = 0
			else
				-- open paren is in right before current
				if p == plnum then

					-- INFO: check nested brackets
					local pp = search_bracket(lnum, 'bW')[1]
					if pp > 0 then
						-- Nested Paren: 기준 들여쓰기 + nested_paren 설정값
						debugprint('line-184: ' .. tostring(prev_indent))
						return prev_indent + config.nested_paren or vim.bo.shiftwidth
					end

					-- INFO: check single bracket
					debugprint('line-189: ' .. tostring(prev_indent))
					return prev_indent + config.open_paren or vim.bo.shiftwidth
				end

				if plnumstart == p then
					debugprint('line-194: ' .. tostring(prev_indent))
					return prev_indent
				end
				debugprint('line-197: ' .. tostring(plindent))
				return plindent
			end
		end
	end


	-- these are executes after cursor is moved to next line.
	-- get line contents(pline) of previous line except of part of comment region
	local pline = prev_line
	local pline_len = #pline
	if vim.fn.has('syntax_items') == 1 and node_matches(prev_lnum, pline_len, {'comment', 'todo'}) then
		-- If the line is end with comment region,
		-- Binary search to detect comment start column exactly
		-- min is start of comment, the contents in front of min is get.
		pline = get_validstr(prev_lnum)
	else
		-- alternative method : checking #, but it cannot detect # in string.
		local col = pline:find('#')
		if col then
			pline = pline:sub(1, col - 1)
		end
	end

	-- INFO: if the previous line is ended with colon(:), indent this line
	if pline:match(':%s*$') then
		debugprint('line-232: ' .. tostring(plindent + vim.bo.shiftwidth))
		return plindent + vim.bo.shiftwidth
	end

	-- INFO: if the previous line is ended with break|continue|raise|return|pass
	-- if data.decode(enc):
	-- 		return enc<CR>
	-- | <- next cursor location
	if vim.fn.match(prev_line, [[^\s*\(break\|continue\|raise\|return\|pass\)\s]]) >= 0 then
		if dedented(lnum, prev_indent) then
			debugprint('line-242: ' .. tostring(-1))
			return -1 -- remain if it is dedented already
		end
		debugprint('line-232: ' .. tostring(prev_indent + vim.bo.shiftwidth))
		return prev_indent - vim.bo.shiftwidth -- dedent
	end

	-- INFO: if the current line is edited with except|finally
	-- align 'except|finally' to same indent with 'try' when inserting except|finally
	-- try:
	-- 		test
	-- 		except|   <- it will dedented if you insert whole 'except:' or 'finally:'
	--
	-- \> means end of word boundary, filter this case like 'except_handler'
	if vim.fn.match(line, [[^\s*\(except\|finally\)\>]]) >= 0 then
		-- find try|except to upwards
		for row = lnum - 1, 1, -1 do
			if vim.fn.match(vim.fn.getline(row), [[^\s*\(try\|except\)\>]]) >= 0 then
				-- if upper keyword(try) is less indented than current(except), align indent of except to try
				local row_indent = vim.fn.indent(row)
				if row_indent < cur_indent then
					debugprint('line-263: ' .. tostring(row_indent))
					return row_indent
				end
				debugprint('line-266: ' .. tostring(-1))
				return -1
			end
		end
		-- if try|except cannot be found
		debugprint('line-271: ' .. tostring(-1))
		return -1
	end


	-- INFO: if current line is 'elif|else', dedent to align with 'if'
	-- align elif / else when these are inserted.
	if vim.fn.match(line, [[^\s*\(elif\|else\)\>]]) >= 0 then
		-- if previous line is one-linear, remain previous indent
		-- If cannot occurs in python but it seems that bitbake or multiple language editing.
		if vim.fn.match(vim.fn.getline(plnumstart), [[^\s*\(for\|if\|elif\|try\)\>]]) >= 0 then
			debugprint('line-282: ' .. tostring(plindent))
			return plindent
		end
		-- if current line is dedented already, ignore
		if dedented(lnum, plindent) then
			debugprint('line-287: ' .. tostring(-1))
			return -1
		end
		-- dedent occurs for elif, else
		debugprint('line-291: ' .. tostring(plindent - vim.bo.shiftwidth))
		return plindent - vim.bo.shiftwidth
	end

	-- INFO: after closing parentheses, the indent will be restore
	-- a = (b
	-- 		+c)<CR>
	-- |  <-  cursor will go to here
	-- vim.print(lnum)
	-- vim.print(parlnum)
	-- vim.print(node_matches(lnum, vim.fn.col('.'), {'comment', 'string', 'todo'}))
	if parlnum > 0 then
		if dedented(lnum, plindent) then
			debugprint('line-301: ' .. tostring(-1))
			return -1
		end
		debugprint('line-304: ' .. tostring(plindent))
		return plindent
	end

	debugprint('line-308: ' .. tostring(-1))
	return -1
end

vim.api.nvim_create_user_command('PythonMatch', function (args)
	local lnum = vim.fn.line('.')
	local col = vim.fn.col('.')
	-- vim.print(search_bracket(lnum, 'nbW'))
end, {
	nargs = 0,
	desc = 'test',
})

-- Assign the indent function to a global variable (g) so that it can be accessed from indentexpr.
vim.opt_local.indentexpr = 'v:lua.python_indent_user(v:lnum)'


