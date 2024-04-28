return {
	-- LSP progess message with mini notifying format
	'j-hui/fidget.nvim',
	event = 'LspAttach',
	config = function()
		require('fidget').setup({
			progress = {
				ignore = {'ltex'},		-- because ltex progress always operate when write character
			}

		})
	end
}
-- noice.nvim : it is good, but it makes neovim cursor moving slower / substitute command bug that cannot move cursor
