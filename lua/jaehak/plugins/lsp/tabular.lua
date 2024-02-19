return {
	'godlygeek/tabular',
	event = 'VeryLazy',
	config = function()
		vim.keymap.set('v', '<C-=>', '<Cmd>Tabularize /', {desc = 'tabularize'})
	end
}
