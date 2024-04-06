return {
	-- translation
	-- FIXME: it doesn't work at my workplace PC environment, I think it is the HTTP authority problem
	'uga-rosa/translate.nvim',
	event = 'VeryLazy',
	config = function ()
		local translate = require('translate')
		translate.setup({
			default = {
				command = 'google',		-- use google translate with curl
				output = 'floating',
			},
			preset = { 					-- preset setting for options
				output = {
					floating = {
						relative = 'cursor',
						border = 'single'
					},
				}
			}

		})


		vim.keymap.set({'n', 'x'},'<leader>te',
			function()
				vim.cmd(':Translate EN -output=replace')
				vim.api.nvim_input('<Esc>')
			end, {desc = 'translate to english and replace'} )

		vim.keymap.set({'n', 'x'},'<leader>tk',
			function()
				vim.cmd(':Translate KO -output=replace')
				vim.api.nvim_input('<Esc>')
			end, {desc = 'translate to korean and replace'} )

		vim.keymap.set({'n', 'x'},'<leader>tE',
			function()
				vim.cmd(':Translate EN')
				vim.api.nvim_input('<Esc>')
			end, {desc = 'translate to english and show'} )

		vim.keymap.set({'n', 'x'},'<leader>tK',
			function()
				vim.cmd(':Translate KO')
				vim.api.nvim_input('<Esc>')
			end, {desc = 'translate to korean and show'} )
	end
}
-- potamides/pantran.nvim : i don't need to translate window yet.
