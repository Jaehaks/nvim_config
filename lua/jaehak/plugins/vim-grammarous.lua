return {
	'rhysd/vim-grammarous',
	enabled = false,
	-- vim plugin cannot use lazy load
	config = function()
		vim.cmd([[
			let g:grammarous#default_comments_only_filetypes = {
				\ '*' : 1,
				\ 'help' : 0,
				\ 'markdown' : 0,
				\ 'text' : 0, 
				\ }
			let g:grammarous#disabled_rules = {
				\ '*' : ['WHITESPACE_RULE', 'EN_QUOTES'],
				\ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
				\ }
			let g:grammarous#languagetool_cmd = 'languagetool'
		]])
		-- 3) use "languagetool" from external
		-- 	  this plugin install languagetool using curl but i installed manually (scoop install languagetool-java)

		vim.keymap.set({'n', 'v'}, '<leader>tg', '<Cmd>GrammarousCheck<CR>', {desc = 'Check grammar'})
	end
}
