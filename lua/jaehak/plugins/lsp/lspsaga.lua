return {
	'nvimdev/lspsaga.nvim',		-- improved lsp actions
	enabled = true,
	event = 'LspAttach',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons'
	},
	config = function ()
		require('lspsaga').setup({
			-- ////// hover : library definition //////////
			hover = {					-- "KK" makes cursor move into hover window
				open_link = '<C-]>',   -- it can use website link also.
				open_cmd = '!chrome'
			},
			-- ////// outline : code tree //////////	
			outline = {
				layout = 'float',
				detail = true,
			},
			-- ////// lightbulb : code action notify //////// 
			lightbulb = {
				enable = false,		-- lightbulb makes screen shake, I don't know why
			},
			definition = {
				keys = {
					edit = 'o'
				}
			},
			-- ///// floatterm : floating terminal module ////////
			floaterm = {
				height = 0.3,
			}
		})

		vim.keymap.set('n', '<leader>lo', '<Cmd>Lspsaga outline<CR>', {desc = 'outline', silent = true, noremap = true})
		vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', {desc = 'hover_doc', silent = true, noremap = true})
--		vim.keymap.set('n', '<C-\\>', '<Cmd>Lspsaga term_toggle<CR>', {desc = 'toggle term', silent = true, noremap = true})
		-- toggle term must close using :q! not :q
		-- lspsaga toggle term can use after lsp attatch only
	end
}
