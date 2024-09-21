return {
	'folke/trouble.nvim',
	event = 'LspAttach',
	dependencies = {'nvim-tree/nvim-web-devicons'},
	opts = {},
	config = function ()
		local trouble = require('trouble')
		trouble.setup({
			action_keys = {
				next = 'k',			-- change move key
				previous = 'j',		-- change move key 
			},
--			auto_open = true,
		})
		vim.keymap.set({'n'}, '<leader>xt', function() trouble.toggle('document_diagnostics') end)
	end
}
