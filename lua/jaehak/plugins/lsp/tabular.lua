return {
	'godlygeek/tabular',
	event = 'VeryLazy',
	config = function()
		vim.keymap.set('v', '<C-=>', ':Tabularize /', {desc = 'tabularize'})
	end
}
