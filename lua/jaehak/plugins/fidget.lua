return {
	-- LSP progess message with mini notifying format
	'j-hui/fidget.nvim',
	event = 'LspAttach',
	config = function()
		require('fidget').setup({
			progress = {
				ignore_done_already = true,
				ignore_empty_message = true,
				ignore = {'ltex'},		-- because ltex progress always operate when write character
			},
			logger = {
				level = vim.log.levels.OFF, -- disable logging

			}
		})
	end
}
-- noice.nvim : it is good, but it makes neovim cursor moving slower / substitute command bug that cannot move cursor
