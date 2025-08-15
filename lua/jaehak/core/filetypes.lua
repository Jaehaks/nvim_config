-- force modify filetype
vim.filetype.add({
	extension = {
		scm = 'query', -- .scm is 'scheme' as default, 'query' is more colorful
	},
	filename = {
		['.vindrc'] = 'vim',
	}
})

if not vim.g.has_win32 then
	-- set filetype of zsh as sh to recognize bash treesitter
	vim.filetype.add({
		extension = {
			zsh = 'sh',
			sh = 'sh'
		},
		filename = {
			['.zshrc'] = 'sh',
			['.zshenv']= 'sh',
		}
	})
end
