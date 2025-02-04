return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	init = function()
		vim.opt.timeout = true
		vim.opt.timeoutlen = 500
	end,
	opts = {
	},
	config = function()
		local wk = require('which-key')
		-- which-key plugin setup
		wk.setup({
			plugins = {
				presets = {
					operators = false,
					z = false,
				}
			},
		})

		wk.add({
			{'<leader>c', group = 'Color'               , mode = 'n'},
			{'<leader>e', group = 'File explorer'       , mode = 'n'},
			{'<leader>f', group = 'Snacks'              , mode = 'n'},
			{'<leader>x', group = 'Trouble'             , mode = 'n'},
			-- {'<leader>l', group = 'Lspsaga', mode = 'n'},
			{'<leader>m', group = 'Markdown'            , mode = 'n'},
			{'<leader>n', group = 'Minimap'             , mode = 'n'},
			{'<leader>h', group = 'Gitsign'             , mode = 'n'},
			{'<leader>g', group = 'Neogit'              , mode = 'n'},
			{'<leader>p', group = 'Project'             , mode = 'n'},
			{'<leader>s', group = 'Nvim-spectre'        , mode = {'n', 'v'}},
			{'<leader>t', group = 'Terminal / Translate', mode = 'n'},
			{'<leader>t', group = 'Translate'           , mode = 'v'},
			{'<leader>w', group = 'Formatter'           , mode = {'n', 'v'}},
		})

	end
}
