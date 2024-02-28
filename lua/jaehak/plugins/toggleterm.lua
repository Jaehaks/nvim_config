return {
	'akinsho/toggleterm.nvim',
	version = '*',
	config = function()
		local toggleterm = require('toggleterm')
		toggleterm.setup({
			size = 10, 	-- terminal size
--			open_mapping = [[<leader>j]],
			shade_terminals = true,
			shading_factor = -100,	-- make terminal color to black
			persist_mode = false,	-- don't remember previous terminal mode
		})
 
		-- key mapping in terminal mode
		function _G.set_terminal_keymaps()
			local opts = {buffer = 0, noremap = true}
			vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts) 	-- out from terminal mode
			vim.keymap.set('t', '<C-h>', [[<Left>]], opts)			-- cursor move in terminal mode
			vim.keymap.set('t', '<C-j>', [[<Up>]], opts)
			vim.keymap.set('t', '<C-k>', [[<Down>]], opts)
			vim.keymap.set('t', '<C-l>', [[<Right>]], opts)
			vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)	-- move other window, <C-w>h, j ,k l, w
			vim.keymap.set('t', '<C-d>', [[<Esc><Cmd>q!<CR>]], opts)
		end
		local opts = {noremap = true}
		vim.keymap.set('n', '<C-\\>', 		  '<Cmd>exe v:count1 . "ToggleTerm dir=%:p:h"<CR>', opts)
		vim.keymap.set({'i','t'}, '<C-\\>',   '<Esc><Cmd>exe "ToggleTerm"<CR>', opts)
		vim.keymap.set('n', '<C-S-\\>', 	  '<Cmd>ToggleTermToggleAll<CR>', opts)
		vim.keymap.set({'i','t'}, '<C-S-\\>', '<Esc><Cmd>ToggleTermToggleAll<CR>', opts)

		-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	--	vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
		vim.api.nvim_create_autocmd('TermOpen', {
			pattern = 'term://*',
			desc = 'set keymaps on terminal',
			callback = set_terminal_keymaps
		})
	end
}
