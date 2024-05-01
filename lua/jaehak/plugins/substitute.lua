return {
	-- substitute contents automatically from default register 
	'gbprod/substitute.nvim',
	config = function ()
		local sub = require('substitute')
		sub.setup({
		})

		vim.keymap.set("n", "s" , require('substitute').operator, { noremap = true , desc = 'substitute operator'})
		vim.keymap.set("n", "ss", require('substitute').line    , { noremap = true , desc = 'substitute line'})
		vim.keymap.set("n", "S" , require('substitute').eol     , { noremap = true , desc = 'substitute eok'})
		vim.keymap.set("x", "s" , require('substitute').visual  , { noremap = true , desc = 'substitute visual'})
	end
}
