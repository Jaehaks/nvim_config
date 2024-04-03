return {
{
	"numToStr/FTerm.nvim",
	enabled = true,
	config = function ()
		local fterm = require('FTerm')
		fterm.setup({
			ft = 'FTerm',
			border = 'rounded',
			cmd = 'cmd',
			dimensions = {
				height = 0.4,
				width = 0.9,
				x = 0.5,
				y = 0.9,
			}
		})

		vim.keymap.set('n', '<leader>tt',fterm.toggle, {desc = 'open FTerm'} )
	end
},
-- vim-floaterm : cannot select position in detail, but it seems faster than FTerm
}
