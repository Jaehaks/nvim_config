return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'BurntSushi/ripgrep',
		'sharkdp/fd',
--		'nvim-treesitter/nvim-tresitter',
		'nvim-tree/nvim-web-devicons',
		{
		'nvim-telescope/telescope-fzf-native.nvim',
			build = [[cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release 
				   && cmake --build build --config Release 
				   && cmake --install build --prefix build]],
		},
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')
		local actions_fb = require('telescope._extensions.file_browser.actions')
		telescope.setup({
			-- ////// default settings //////////
			defaults = {
				layout_strategy = 'horizontal',
				layout_config = {
					anchor = 'S',	-- show layout window pinned to south (bottom) 
					height = 0.45,	-- make smaller height 0.9 -> 0.45
				},
				mappings = {
					n = {	-- chnage normal mode keymaps
						['j'] = actions.move_selection_previous,
						['k'] = actions.move_selection_next,
					},
				},
				path_display = { truncate = 3 },
			},
			pickers = {
				-- ///////// pikcer : find_files ////////
				find_files = {
					search_dirs = {'%:p:h'},
				},
				-- ///////// pikcer : oldfiles ////////
				oldfiles = {
					initial_mode = 'normal'
				},
				-- ///////// picker : live_grep /////////
				live_grep = {
					search_dirs = {'%:p:h'}			-- only search current folder
				},
			},
			extensions = {
				-- //////// extensions : file_browser ////////////
				file_browser = {
					path = '%:p:h', 		-- start dir,  expanded auto
					select_buffer = true,	-- select current buffer
					initial_mode = 'normal',
					mappings = {
						['n'] = {
							['-'] = actions_fb.goto_parent_dir,
							['o'] = actions_fb.open,
						}
					}
				},
				-- //////// extensions : fzf sorter (for find_files) ////////////
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = 'smart_case',
				}
			},
		})
		telescope.load_extension('fzf')
		telescope.load_extension('file_browser')

		-- ////// telescope-fzf-navie.nvim //////
		-- 1) need cmake for windows (cmake windows x64 installer)
		-- 2) add system path with cmake

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files,	 	{desc = 'find_files'})
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, 		{desc = 'live_grep'})		-- live grep
		vim.keymap.set('n', '<leader>fo', builtin.oldfiles, 		{desc = 'recent files'}) 		-- recent files
		vim.keymap.set('n', '<leader>fb', builtin.buffers, 			{desc = 'buffer list'}) 			-- buffer list 
		vim.keymap.set('n', '<leader>fc', builtin.command_history, 	{desc = 'command history'}) 	-- command history 
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, 		{desc = 'help tags list'}) 		-- search tag for help
		vim.keymap.set('n', '<leader>fm', builtin.marks, 			{desc = 'mark list'}) 			-- marks list
		vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find, {desc = 'find in current buffer'}) 	-- search list in current buffer

		vim.keymap.set('n', '<leader>fl', telescope.extensions.file_browser.file_browser, {desc = 'file_browser'})
--		vim.keymap.set('n', '<leader>fl', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', {desc = 'file_browser'})
	end
}
