return {
	-- LSP progess message with mini notifying format
	'j-hui/fidget.nvim',
	event = 'LspAttach',
	opts = {
		progress = {
			suppress_on_insert = true, -- suppress new messages while insert
			ignore_done_already = true,
			ignore_empty_message = true,
			ignore = { -- After #a01443a, add function
				'ltex',	-- because ltex progress always operate when write character
				function (msg)
					return msg.lsp_client.name == 'lua_ls' and string.find(msg.title, 'Diagnosing')
				end,
			},
		},
		notification = {
			window = {
				max_width = 0, -- disable width limit of message
			}
		},
		logger = {
			level = vim.log.levels.OFF, -- disable logging
		}
	}
}
-- noice.nvim : it is good, but it makes neovim cursor moving slower / substitute command bug that cannot move cursor
