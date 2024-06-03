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
			triggers_blacklist = {
				i = {'j', 'k', 'f'} -- don't show which key panel when you type this list in 'i' mode
			}
		})

		-- manually register's opts
		local nopts = {
		  mode = "n", -- NORMAL mode
		  prefix = "<leader>",
		  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		  silent = true, -- use `silent` when creating keymaps
		  noremap = true, -- use `noremap` when creating keymaps
		  nowait = true, -- use `nowait` when creating keymaps
		}


		-- mapping 
		local nmappings = {
			c = { name = 'Color' },
			e = { name = 'Oil explorer' },
			f = { name = 'Telescope' },
			x = { name = 'Trouble' },
			l = { name = 'Lspsaga' },
			m = { name = 'Markdown' },
			h = { name = 'Gitsign' },
			g = { name = 'Neogit' },
			p = { name = 'Project'},
			s = { name = 'Nvim-spectre'},
			t = { name = 'Terminal / Translate'},
			w = { name = 'Formatter'},
		}

		-- manually register's opts
		local vopts = {
		  mode = "v", -- VISUAL mode
		  prefix = "<leader>",
		  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		  silent = true, -- use `silent` when creating keymaps
		  noremap = true, -- use `noremap` when creating keymaps
		  nowait = true, -- use `nowait` when creating keymaps
		}


		-- mapping 
		local vmappings = {
			w = { name = 'Formatter' },
			t = { name = 'Translate' },
			s = { name = 'Nvim-spectre' },
		}

		wk.register(nmappings, nopts)	-- register mappings
		wk.register(vmappings, vopts)	-- register mappings
	end
}
