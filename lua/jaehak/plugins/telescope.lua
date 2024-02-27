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
		build = 'make'
--			build = [[cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release 
--				   && cmake --build build --config Release 
--				   && cmake --install build --prefix build]],
		},
	},
	config = function()
		-- call modules 
		local telescope = require('telescope')
		local actions = require('telescope.actions')
		local actions_fb = require('telescope._extensions.file_browser.actions')
		local builtin = require('telescope.builtin')
		local utils = require('telescope.utils')

		-- telescope settings 	
		telescope.setup({
			-- ////// default settings //////////
			defaults = {
				wrap_results = true,
				path_display = { truncate = 3 },
				layout_strategy = 'horizontal',
				layout_config = {
					anchor = 'S',	-- show layout window pinned to south (bottom) 
					height = 0.45,	-- make smaller height 0.9 -> 0.45
				},
				mappings = {
--					i = {
--						['<C-h>'] = '<Left>',
--						['<C-l>'] = '<Right>',
--					},
					n = {	-- chnage normal mode keymaps
						['j'] = actions.move_selection_previous,
						['k'] = actions.move_selection_next,
						['-'] = function (prompt_bufnr)
									local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
									local cwd = current_picker.cwd and tostring(current_picker.cwd) or vim.loop.cwd()
									local parent_dir = vim.fs.dirname(cwd)

									actions.close(prompt_bufnr)
									builtin.find_files{
										results_title = vim.fs.basename(parent_dir),
										cwd = parent_dir,
									}
								end,
						['<C-h>'] = actions.preview_scrolling_left,
						['<C-j>'] = actions.preview_scrolling_up,
						['<C-k>'] = actions.preview_scrolling_down,
						['<C-l>'] = actions.preview_scrolling_right,
						['<Tab>'] = actions.toggle_selection + actions.move_selection_next,
						['<S-Tab>'] = actions.toggle_selection + actions.move_selection_previous,
						['q'] = actions.close,
						['o'] = actions.select_default,


					},
				},
			},
			pickers = {
				-- ///////// pikcer : find_files ////////
				find_files = {
					initial_mode = 'normal'
				},
				-- ///////// pikcer : oldfiles ////////
				oldfiles = {
					initial_mode = 'normal'
				},
				diagnostics = {
					layout_strategy = 'center',
					initial_mode = 'normal',
					sorting_strategy = 'ascending',
					wrap_results = true,
					layout_config = {
						width = 0.99,
					}
				},
				jumplist = {
					initial_mode = 'normal'
				}
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
					case_mode = 'smart_case'
				}
			},
		})
		-- ////// telescope-fzf-navie.nvim //////
		-- 1) need cmake for windows (cmake windows x64 installer)
		-- 2) add system path with cmake
		telescope.load_extension('fzf')
		telescope.load_extension('file_browser')

		TelescopePicker = function(picker)
			local cur_file 		= vim.fn.expand("%:p")
			local cur_dir 		= vim.fn.expand("%:p:h")
			local cur_dir_base	= vim.fs.basename(cur_dir)
			local cur_cwd 		= vim.fn.getcwd()
			local cur_cwd_base 	= vim.fs.basename(cur_cwd)

   			if 		picker == 'find_files' 			then 	builtin.find_files{ results_title = cur_dir_base, cwd = cur_dir, }
			elseif 	picker == 'live_grep' 			then 	builtin.live_grep{  results_title = cur_cwd_base}
			elseif 	picker == 'live_grep_cur_dir' 	then 	builtin.live_grep{  results_title = cur_dir_base, cwd = cur_dir, }
			end
		end
		vim.keymap.set('n', '<leader>ff', [[<Cmd>lua TelescopePicker('find_files')<CR>]],	 		{desc = 'find_files'})
		vim.keymap.set('n', '<leader>fg', [[<Cmd>lua TelescopePicker('live_grep_cur_dir')<CR>]],	{desc = 'live_grep current dir'})
		vim.keymap.set('n', '<leader>fG', [[<Cmd>lua TelescopePicker('live_grep')<CR>]],	 		{desc = 'live_grep'})
		vim.keymap.set('n', '<leader>fo', builtin.oldfiles, 		{desc = 'recent files'})                    -- recent files
		vim.keymap.set('n', '<leader>fb', builtin.buffers, 			{desc = 'buffer list'})                     -- buffer list
		vim.keymap.set('n', '<leader>fc', builtin.command_history, 	{desc = 'command history'})                 -- command history
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, 		{desc = 'help tags list'})                  -- search tag for help
		vim.keymap.set('n', '<leader>fm', builtin.marks, 			{desc = 'mark list'})                       -- marks list
		vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find, {desc = 'find in current buffer'}) -- search list in current buffer
		vim.keymap.set('n', '<leader>fj', builtin.jumplist, 		{desc = 'old jumped cursor location list'}) -- cursor location history
		vim.keymap.set('n', '<leader>fd', builtin.diagnostics, 		{desc = 'diagnostics list'})                -- diagnostics list from lsp
		vim.keymap.set('n', '<leader>fk', builtin.keymaps, 			{desc = 'keymaps list'})                    -- keymaps list
		vim.keymap.set('n', '<leader>fv', builtin.vim_options, 		{desc = 'vim options list'})                -- vim options list

		vim.keymap.set('n', '<leader>fl', telescope.extensions.file_browser.file_browser, {desc = 'file_browser'})
	end
}
