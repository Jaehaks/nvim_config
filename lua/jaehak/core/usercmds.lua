
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



---------- Lsp -----------
vim.api.nvim_create_user_command("LspInfo", function (opts)
	vim.cmd('checkhealth vim.lsp')
end, {desc = 'LspInfo'})


local tab_default = {
	tabstop     = vim.api.nvim_get_option_value('tabstop', {}),
	softtabstop = vim.api.nvim_get_option_value('softtabstop', {}),
	shiftwidth  = vim.api.nvim_get_option_value('shiftwidth', {}),
	expandtab   = vim.api.nvim_get_option_value('expandtab', {}),
}

---------- Editing ------------
-- toggle tab mode (vim.o.shiftwidth, noexpandtab) <-> (shiftwidth = 2, expandtab) for github writing
local function ToggleIndent(opts, mode)
	local start_line = opts.line1 or 1 -- range start
	local end_line = opts.line2 or vim.api.nvim_buf_line_count(0) -- range end
	local bufnr = vim.api.nvim_get_current_buf()
	local shiftwidth = vim.o.shiftwidth

	for lnum = start_line, end_line do
		local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
		if line then
			local indent_spaces = vim.fn.indent(lnum)
			local new_indent_count
			local new_indent

			if mode == 'github' then
				new_indent_count = math.floor(indent_spaces / shiftwidth) * 2 + indent_spaces % shiftwidth
				new_indent = string.rep(" ", new_indent_count)

			elseif mode == 'restore' then
				new_indent_count = math.floor(indent_spaces / 2) * shiftwidth + indent_spaces % 2
				local tabs = math.floor(new_indent_count / shiftwidth)
				local spaces = new_indent_count % shiftwidth
				new_indent = string.rep("\t", tabs) .. string.rep(" ", spaces)

			else
				new_indent = line:match("^[ \t]*") or "" -- remain current state
			end

			-- change line indent
			local trimmed_line = line:gsub("^[ \t]*", "")
			local new_line = new_indent .. trimmed_line
			vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, {new_line})
		end
	end
end


-- {range = true} makes this function can accepts opts.line1/line2/range
vim.api.nvim_create_user_command("ToggleGithubIndent", function(opts)
	local start_line = opts.line1 or 1
	local end_line = opts.line2 or vim.api.nvim_buf_line_count(0)
	local shiftwidth = vim.o.shiftwidth
	local mode = nil

	-- check first line tab indent state
	for lnum = start_line, end_line do
		local line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, false)[1] -- get current line string with escape char
		local indent_str = line:match('^[ \t]*')
		local indent_spaces = vim.fn.indent(lnum) -- get space counts of indent at line

		if indent_spaces == shiftwidth and indent_str:find('\t') then
			mode = 'github'
			break
		elseif indent_spaces == 2 and not indent_str:find('\t') then
			mode = 'restore'
			break
		end
	end

	ToggleIndent(opts, mode)

end, {range = true, desc = "Toggle indent style between github/restore"})


-- scrollbind for all windows
vim.api.nvim_create_user_command('ToggleScrollBind', function ()
	require('jaehak.core.utils').toggle_scrollbind()
end, {desc = 'Toggle scrollbind for all win'})


---------- compile ------------
-- run specific file
vim.api.nvim_create_user_command("Run", function (opts)
	local file = nil
	if opts.fargs[1] and opts.fargs[1] ~= '' then
		file = opts.fargs[1]
	end
	require('jaehak.core.utils').run(file)
end, {nargs = '*', complete = 'file'})
