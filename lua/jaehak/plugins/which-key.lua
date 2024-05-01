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
		local opts = {
		  mode = "n", -- NORMAL mode
		  prefix = "<leader>",
		  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		  silent = true, -- use `silent` when creating keymaps
		  noremap = true, -- use `noremap` when creating keymaps
		  nowait = true, -- use `nowait` when creating keymaps
		}


		-- mapping 
		local mappings = {
			c = { name = 'color' },
			e = { name = 'oil explorer' },
			f = { name = 'telescope' },
			x = { name = 'trouble' },
			l = { name = 'lspsaga' },
			m = { name = 'markdown' },
			h = { name = 'gitsign' },
			g = { name = 'Neogit' },
			p = { name = 'project'},
			s = { name = 'nvim-spectre'},
			t = { name = 'terminal / translate'},
		}

		wk.register(mappings, opts)	-- register mappings
	end
}
