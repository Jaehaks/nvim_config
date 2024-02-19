return {{
	-- ////////// lir - file explorer /////////////
	'tamago324/lir.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'kyazdan142/nvim-web-devicons'
	},
	config = function()
		local actions = require('lir.actions')
		local mark_actions = require('lir.mark.actions')
		local clipboard_actions = require('lir.clipboard.actions')
		local bookmark_actions = require('lir.bookmark.actions')
		local lir = require('lir')

		lir.setup({
			show_hidden_files = true,
			ignore = {},
			devicons = {
				enable = true,
				highlight_dirname = false
			},
			hide_cursor = false,
			float = {
				winblend = 0,		-- transparency 0% 
				win_opts = function()	-- return args for nvim_open_win()
					local width = math.floor(vim.o.columns * 0.3)
					local height = math.floor(vim.o.lines * 0.8)
					return {
						border = 'double',
						row = 2,
						col = 1,
						width = width,
						height = height,
					}
				end,
				curdir_window = {
					enable = true, 		-- show cwd name top of lir (not work?)
					highlight_dirname = false,
				}
			},
			on_init = function() end,
			get_filters =function() end,
			mappings = {
				['h']     = actions.up,
				['l']     = actions.edit,
				['q']     = actions.quit,
				['<C-s>'] = actions.split,
				['<C-v>'] = actions.vsplit,
				['<C-t>'] = actions.tabedit,


				['K']     = actions.mkdir,
				['a']     = actions.newfile,
				['r']     = actions.rename,
				['@']     = actions.cd,
				['Y']     = actions.yank_path,
				['.']     = actions.toggle_show_hidden,
				['D']     = actions.delete,

				['C'] 	  = clipboard_actions.copy,
				['X'] 	  = clipboard_actions.cut,
				['P'] 	  = clipboard_actions.paste,

				['B'] 	  = bookmark_actions.list,
				['ba'] 	  = bookmark_actions.add,
			}
		})

--		vim.api.nvim_create_autocmd({'FileType'}, {
--			pattern = {"lir"},
--			callback = function()
--				-- use visual mode
--				vim.api.nvim_buf_set_keymap( 0, "x", "J", ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>', { noremap = true, silent = true })
--
--				-- echo cwd
--				vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
--			end
--		})

		vim.keymap.set('n', '<leader>ee', '<Cmd>lua require("lir.float").toggle()<CR>', {desc = 'open current buffer folder'})
		vim.keymap.set('n', '<leader>ec', '<Cmd>lua require("lir.float").toggle(vim.fn.stdpath("config") .. "/lua/jaehak/plugins")<CR>', {desc = 'open config folder'})
		vim.keymap.set('n', '<leader>ed', '<Cmd>lua require("lir.float").toggle(vim.fn.stdpath("data") .. "/lazy")<CR>', {desc = 'open config-data folder'})
	end
},{
	-- ////////// lir - git status extension /////////////
	'tamago324/lir-git-status.nvim',
	dependencies = {
		'tamago324/lir.nvim',
	},
	config = function()
		require('lir.git_status').setup({
			show_ignored = false,
		})
	end
},{
	-- ////////// lir - bookmark extension /////////////
	'tamago324/lir-bookmark.nvim',
	dependencies = {
		'tamago324/lir.nvim',
	},
	config = function()
		local b_actions = require('lir.bookmark.actions')
		require('lir.bookmark').setup({
			bookmark_path = vim.fn.stdpath('data') .. '/.lir_bookmark',
			mappings = {
				['l'] = b_actions.edit,
				['<C-s>'] = b_actions.split,
				['<C-v>'] = b_actions.vsplit,
				['<C-t>'] = b_actions.tabedit,
				['q'] = b_actions.open_lir,		-- quit and goto lir
			}

		})
	end
},
}
