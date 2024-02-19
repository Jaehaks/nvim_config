return {
	'nvim-tree/nvim-tree.lua',
	enabled = false,
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- set termguicolors to enable highlight groups
		vim.opt.termguicolors = true

		-- empty setup using defaults
		require("nvim-tree").setup()

		-- OR setup with some options
		require("nvim-tree").setup({
--		  respect_buf_cwd = true,	-- nvim-tree root dir is pwd of current buffer
		  							-- when pwd is changed by :cd, the pwd is applyed 
		  sort = {
			sorter = "case_sensitive",
		  },
		  view = {
			width = 30,
		  },
		  renderer = {
			group_empty = true,
		  },
		  filters = {
			dotfiles = false,  -- if false , show dotfiles
		  },
		  live_filter = {
			  always_show_folders = false,	-- don't show folders without match when find (but all expand is needed)
		  },
		  trash = {
			  cmd = 'trash'
		  },
		  ui = {
			  confirm = {
				  remove = true,
				  trash = false,
				  default_yes = true,
			  }
		  },
		  update_focused_file = {	-- update nvim-tree root dir when opend file is focused
			  enable = false,
			  update_root = false,
		  },
		  actions = {
			  change_dir = {
				  global = true,	-- use :cd instead of :lcd when dir of nvim-tree is changed
			  }
		  }
		})

		function OpenFolder(dir)
			vim.cmd('vsplit! ' .. dir)				-- move nvim-tree root_dir
			if dir == vim.fn.stdpath('config') then	-- expand if it is config dir
--				require('nvim-tree.api').tree.expand_all()
			end
			print(vim.loop.cwd())					-- confirm pwd
		end

		local keymap = vim.keymap
		keymap.set('n', '<leader>ee', ':NvimTreeFindFileToggle<CR>')
		keymap.set('n', '<leader>ef', ':NvimTreeFocus<CR>')
		keymap.set('n', '<leader>ei', '<Cmd>e $MYVIMRC<CR>', {desc = 'open init.lua'})
		keymap.set('n', '<leader>ec', '<Cmd>lua OpenFolder(vim.fn.stdpath("config"))<CR>', {desc = 'open .config/nvim'})
		keymap.set('n', '<leader>ed', [[<Cmd>lua OpenFolder(vim.fn.stdpath('data') .. '\\lazy' )<CR>]], {desc = 'open .config/nvim-data'})

	--	vim.cmd(':NvimTreeFindFile')	-- open nvim-tree at startup
	end
}

