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
					operatores = false,
					z = false,
				}
			}
		})
		
		-- manually resigster's opts
		local opts = {
		  mode = "n", -- NORMAL mode
		  prefix = "<leader>",
		  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		  silent = true, -- use `silent` when creating keymaps
		  noremap = true, -- use `noremap` when creating keymaps
		  nowait = true, -- use `nowait` when creating keymaps
		}
		
		-- func1) open folder
		function OpenFolder(dir)
			vim.cmd('vsplit! ' .. dir)				-- move nvim-tree root_dir
			if dir == vim.fn.stdpath('config') then	-- expand if it is config dir
				require('nvim-tree.api').tree.expand_all()
			end
			print(vim.loop.cwd())					-- confirm pwd
		end

		-- mapping 
		local mappings = {
			e = {
				name = 'nvim-tree', 
				i = {'<Cmd>e $MYVIMRC<CR>', 'open init.lua'},
				c = {[[<Cmd>lua OpenFolder(vim.fn.stdpath('config'))<CR>]], 'open .config/nvim'},
				d = {[[<Cmd>lua OpenFolder(vim.fn.stdpath('data') .. '\\lazy')<CR>]], 'open .config/nvim-data'},
			},
			f = {
				name = 'telescope'
			},
			x = {
				name = 'trouble'
			}
		}


		wk.register(mappings, opts)	-- register mappings
	end
}
