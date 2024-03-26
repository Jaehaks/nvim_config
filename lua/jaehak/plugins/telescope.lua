return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'BurntSushi/ripgrep',
		'sharkdp/fd',
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
		{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make'
		},
		-- cder.nvim : (extension) change pwd using telescope, not useful to me, and 'ls' has invalid argument error
		-- 			   it is useful when I want to subdirectories list and files quick
	},
	config = function()
		-- call modules 
		local telescope  = require('telescope')
		local actions    = require('telescope.actions')
		local builtin    = require('telescope.builtin')
		local actions_fb = require('telescope._extensions.file_browser.actions')
		-- local utils      = require('telescope.utils')

		-- telescope settings 	
		telescope.setup({
			-- ////// default settings //////////
			defaults = {
				initial_mode = 'normal',
--				path_display = { truncate = 3 },
				layout_strategy = 'horizontal',
				layout_config = {
					anchor = 'S',	-- show layout window pinned to south (bottom) 
					height = 0.45,	-- make smaller height 0.9 -> 0.45
				},
				vimgrep_arguments = {	-- cmd for live_grep / grep_string
					'rg',
					'--color=never',
					'--no-heading',
					'--with-filename',	-- must use
					'--line-number',
					'--column',
					'--smart-case',
					'--fixed-strings'  -- do not use regex
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
						['<c-h>']   = actions.preview_scrolling_left,
						['<C-j>']   = actions.preview_scrolling_up,
						['<C-k>']   = actions.preview_scrolling_down,
						['<C-l>']   = actions.preview_scrolling_right,
						['<C-S-h>'] = actions.results_scrolling_left,
						['<C-S-j>'] = actions.results_scrolling_up,
						['<C-S-k>'] = actions.results_scrolling_down,
						['<C-S-l>'] = actions.results_scrolling_right,
						['<Tab>']   = actions.toggle_selection + actions.move_selection_next,
						['<S-Tab>'] = actions.toggle_selection + actions.move_selection_previous,
						['q']       = actions.close,
						['o']       = actions.select_default,


					},
				},
			},
			pickers = {
				find_files = {
					initial_mode = 'insert'
				},
				live_grep = {
					initial_mode = 'insert'
				},
				diagnostics = {
					layout_strategy = 'center',
					layout_config = {
						width = 0.99,
					},
					sorting_strategy = 'ascending',
--					line_width = 'full',			-- if full, filename list will be not aligned 
				},
				jumplist = {
					trim_text = true		-- show only line information
				},
				marks = {
					mark_type = 'local'  	-- don't need numbered marks
				}
			},
			extensions = {
				-- //////// extensions : file_browser ////////////
				file_browser = {
					path = '%:p:h', 		-- start dir,  expanded auto
					select_buffer = true,	-- select current buffer
					mappings = {
						['n'] = {
							['-'] = actions_fb.goto_parent_dir,
							['o'] = actions_fb.open,
						}
					}
				},
				-- //////// extensions : fzf sorter (for find_files) ////////////
				fzf = {
					--fuzzy = true,			-- only use exact word 
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = 'smart_case'
				},
			},
		})
		-- ////// telescope-fzf-navie.nvim //////
		-- 1) need cmake for windows (cmake windows x64 installer)
		-- 2) add system path with cmake
		telescope.load_extension('fzf')
		telescope.load_extension('file_browser')
		telescope.load_extension('luasnip')


		-- set line number in preview
		vim.api.nvim_create_autocmd({'User'},{
			pattern = 'TelescopePreviewerLoaded',
			command = 'setlocal number',
		})


		-- ///// telescope caller ///////
		TelescopePicker = function(picker)
			local cur_buf 		= vim.fn.expand("%")
			local cur_dir 		= vim.fn.expand("%:p:h")
			local cur_dir_base	= vim.fs.basename(cur_dir)

   			if 		picker == 'find_files' 			then 	builtin.find_files{   results_title = cur_dir_base, cwd = cur_dir, }
			elseif 	picker == 'live_grep_cur_buf' 	then 	builtin.live_grep{    results_title = cur_buf, 	    cwd = cur_dir, search_dirs = {cur_buf}, sorting_strategy = 'ascending'}
			elseif 	picker == 'live_grep_cur_dir'	then 	builtin.live_grep{    results_title = cur_dir_base, cwd = cur_dir, }
			elseif 	picker == 'grep_string_cur_buf'	then 	builtin.grep_string{  results_title = cur_buf, 		cwd = cur_dir, search_dirs = {cur_buf}, sorting_strategy = 'ascending'}
			elseif 	picker == 'diagnostics_cur_buf'	then 	builtin.diagnostics{  results_title = cur_buf, 	    cwd = cur_dir, bufnr = 0}	-- if buf=0, filename column doesn't be shown
			elseif 	picker == 'diagnostics_all_buf'	then 	builtin.diagnostics{  results_title = cur_dir_base, cwd = cur_dir, root_dir = true}	-- search only current buffer dir
			end
		end

		vim.keymap.set('n', '<leader>ff', [[<Cmd>lua TelescopePicker('find_files')<CR>]],	 		{desc = 'find_files'})
		vim.keymap.set('n', '<leader>fg', [[<Cmd>lua TelescopePicker('live_grep_cur_buf')<CR>]],	{desc = 'live_grep current dir'})
		vim.keymap.set('n', '<leader>fG', [[<Cmd>lua TelescopePicker('live_grep_cur_dir')<CR>]],	 		{desc = 'live_grep'})
		vim.keymap.set('n', '<leader>fw', [[<Cmd>lua TelescopePicker('grep_string_cur_buf')<CR>]],	 		{desc = 'grep_string cur_buf'})
		vim.keymap.set('n', '<leader>fo', builtin.oldfiles, 		{desc = 'recent files'})                    -- recent files
		vim.keymap.set('n', '<leader>fb', builtin.buffers, 			{desc = 'buffer list'})                     -- buffer list
		vim.keymap.set('n', '<leader>fc', builtin.command_history, 	{desc = 'command history'})                 -- command history
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, 		{desc = 'help tags list'})                  -- search tag for help
		vim.keymap.set('n', '<leader>fm', builtin.marks, 			{desc = 'mark list'})                       -- marks list
		vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find, {desc = 'find in current buffer'}) -- search list in current buffer
		vim.keymap.set('n', '<leader>fj', builtin.jumplist, 		{desc = 'old jumped cursor location list'}) -- cursor location history
		vim.keymap.set('n', '<leader>fd', [[<Cmd>lua TelescopePicker('diagnostics_cur_buf')<CR>]],	{desc = 'diagnostics cur_buf'})
		vim.keymap.set('n', '<leader>fD', [[<Cmd>lua TelescopePicker('diagnostics_all_buf')<CR>]],	{desc = 'diagnostics all_buf in cur_dir'})
		vim.keymap.set('n', '<leader>fk', builtin.keymaps, 			{desc = 'keymaps list'})                    -- keymaps list
		vim.keymap.set('n', '<leader>fv', builtin.vim_options, 		{desc = 'vim options list'})                -- vim options list

		vim.keymap.set('n', '<leader>fe', telescope.extensions.file_browser.file_browser, {desc = 'file_browser'})
		vim.keymap.set('n', '<leader>fl', telescope.extensions.luasnip.luasnip, {desc = 'luasnip browser'})
	end
}
-- linrongbin16/fzfx.nvim : too slow starup loading / preview loading than telescope, and many errors in windows
