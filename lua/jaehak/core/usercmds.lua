
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
vim.api.nvim_create_user_command("Tabgit", function (opts)
	if vim.api.nvim_get_option_value('tabstop', {}) == tab_default.tabstop then
		vim.opt.tabstop     = 2
		vim.opt.softtabstop = 2
		vim.opt.shiftwidth  = 2
		vim.opt.expandtab   = true
	else
		vim.opt.tabstop     = tab_default.tabstop
		vim.opt.softtabstop = tab_default.softtabstop
		vim.opt.shiftwidth  = tab_default.shiftwidth
		vim.opt.expandtab   = tab_default.expandtab
	end

	if opts.range == 2 then
		vim.cmd('normal! gv=')
	else
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd('normal! gg=G')
		vim.api.nvim_win_set_cursor(0, pos)
	end
end, {desc = 'Toggle to make tab size 2'})
