return {
	'nvim-telescope/telescope.nvim',
	event = 'VeryLazy',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'BurntSushi/ripgrep',
		'sharkdp/fd',
		'nvim-treesitter/nvim-treesitter', -- lazy loading of treesitter makes error in previewer
		'nvim-tree/nvim-web-devicons',
		'catgoose/telescope-helpgrep.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make'
		},
		'nvim-telescope/telescope-file-browser.nvim',
		-- cder.nvim : (extension) change pwd using telescope, not useful to me, and 'ls' has invalid argument error
		-- 			   it is useful when I want to subdirectories list and files quick
	},
	config = function()
		-- call modules 
		local telescope  = require('telescope')
		local actions    = require('telescope.actions')
		local builtin    = require('telescope.builtin')
		local actions_fb = require('telescope._extensions.file_browser.actions')
		local utils      = require('telescope.utils')

		-- telescope settings 	
		telescope.setup({
			-- ////// default settings //////////
			defaults = {
				initial_mode = 'normal',
				path_display = function (opts, path) -- display path only basename
					-- sometimes neovim saved old file path in shada file using '/' delimiter. is it bug?
					-- this makes duplicated lists and doesn't be affected by path argument
					-- it means that if path_display function returns single string 'test', 
					-- the paths with '/' are shown literally. These are not listed in 'path' argument
					-- The solution does not exist in currently. I should modify the string '/' in shada file to '\\'
					-- if PR(#3103) accepted, this problem will be removed.
					local PATH = path
					if vim.g.has_win32 == 1 then
						PATH = PATH:gsub('/','\\') -- sometimes path has '/' as delimiter instead of '\\'
					end
					local tail = utils.path_tail(PATH)
					local basename = vim.fs.basename(vim.fs.dirname(PATH)) .. '/'
					if basename == vim.fs.basename(vim.fn.expand('%:p:h')) .. '/' then
						basename = ''
					end
					if vim.g.has_win32 == 1 then
						basename = basename:gsub('/','\\') -- sometimes path has '/' as delimiter instead of '\\'
					end
					return string.format('%s%s', basename, tail)
				end,
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
					i = {
						['<C-h>'] = function() vim.api.nvim_input('<Left>') end,
						['<C-l>'] = function() vim.api.nvim_input('<Right>') end,
					},
					n = {	-- chnage normal mode keymaps
						['j']       = actions.move_selection_previous,
						['k']       = actions.move_selection_next,
						['<c-h>']   = actions.preview_scrolling_left,
						['<C-j>']   = actions.preview_scrolling_up,
						['<C-k>']   = actions.preview_scrolling_down,
						['<C-l>']   = actions.preview_scrolling_right,
						['<A-h>']   = actions.results_scrolling_left,
						['<A-j>']   = actions.results_scrolling_up,
						['<A-k>']   = actions.results_scrolling_down,
						['<A-l>']   = actions.results_scrolling_right,
						['<Tab>']   = actions.toggle_selection + actions.move_selection_next,
						['<S-Tab>'] = actions.toggle_selection + actions.move_selection_previous,
						['q']       = actions.close,
						['o']       = actions.select_default,
						['<C-f>']   = actions.select_horizontal,
						['<C-v>']   = actions.select_vertical,
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
				},
				oldfiles = {
					file_ignore_patterns = {'doc\\', 'doc/', 'COMMIT_EDITMSG'}
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
				-- //////// extensions : helpgrep (find word without tags) ////////////
				helpgrep = { -- cannot support detour floating window
					ignore_paths = {
						vim.fn.stdpath('state') .. '/lazy/readme',
					},
					mappings = {
						n = { ['<CR>'] = actions.select_default, },
						i = { ['<CR>'] = actions.select_default, }
					}
				}
			},
		})
		-- ////// telescope-fzf-navie.nvim //////
		-- 1) need cmake for windows (cmake windows x64 installer)
		-- 2) add system path with cmake
		telescope.load_extension('fzf')
		telescope.load_extension('file_browser')
		telescope.load_extension('helpgrep')


		-- set line number in preview
		vim.api.nvim_create_autocmd({'User'},{
			pattern = 'TelescopePreviewerLoaded',
			command = 'setlocal number',
		})


		-- ///// telescope caller ///////
		-- TODO: select git directory to use cwd
		-- @param picker <fun()> : picker when current dir is not in git directory
		local CheckGitDir = function (picker)
			-- builtin.git_files() invokes error when it is not git directory
			-- but find_files ignore also .gitignore file
			local ignore_patterns = {'slprj/', '.git/', '%.asv'}
			local opts = {}

			opts.cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
			if vim.v.shell_error ~= 0 then -- if it it not git repository, 1) find lsp root_dir 2) find cwd
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_active_clients({bufnr = bufnr})
				for _, client in pairs(clients) do --  assume that filetype lsp will be first
					opts.cwd = client.config.root_dir
					break
				end
				opts.cwd = vim.fn.getcwd() -- if lsp doesn't exist, use cwd()
			end
			if vim.g.has_win32 == 1 then
				opts.cwd = opts.cwd:gsub('/','\\') -- the delimiter '/' makes displaying absolute path in oldfiles 
													-- solution of duplicated problem as I think
				for i, pattern in ipairs(ignore_patterns) do
					ignore_patterns[i] = pattern:gsub('/', '\\')
				end
			end
			opts.title = vim.fs.basename(opts.cwd)
			picker({
				results_title = opts.title,
				cwd = opts.cwd,
				file_ignore_patterns = ignore_patterns,
				hidden = true
			})
		end

		TelescopePicker = function(pickName)
			local cur_buf 		= vim.fn.expand("%")
			local cur_dir 		= vim.fn.expand("%:p:h")
			local cur_dir_base	= vim.fs.basename(cur_dir)

   			if 		pickName == 'find_files' 			then 	CheckGitDir(builtin.find_files)
			elseif 	pickName == 'live_grep_cur_buf' 	then 	builtin.live_grep{    results_title = cur_buf, 	    cwd = cur_dir, search_dirs = {cur_buf}, sorting_strategy = 'ascending'}
			elseif 	pickName == 'live_grep_cur_dir'		then 	CheckGitDir(builtin.live_grep)
			elseif 	pickName == 'grep_string_cur_buf'	then 	builtin.grep_string{  results_title = cur_buf, 		cwd = cur_dir, search_dirs = {cur_buf}, sorting_strategy = 'ascending'}
			elseif 	pickName == 'diagnostics_cur_buf'	then 	builtin.diagnostics{  results_title = cur_buf, 	    cwd = cur_dir, bufnr = 0}	-- if buf=0, filename column doesn't be shown
			elseif 	pickName == 'diagnostics_all_buf'	then 	builtin.diagnostics{  results_title = cur_dir_base, cwd = cur_dir, root_dir = true}	-- search only current buffer dir
			end
		end

		vim.keymap.set('n', '<leader>ff', [[<Cmd>lua TelescopePicker('find_files')<CR>]],	 		{desc = 'find_files'})
		vim.keymap.set('n', '<leader>fg', [[<Cmd>lua TelescopePicker('live_grep_cur_buf')<CR>]],	{desc = 'live_grep current dir'})
		vim.keymap.set('n', '<leader>fG', [[<Cmd>lua TelescopePicker('live_grep_cur_dir')<CR>]],	 		{desc = 'live_grep'})
		vim.keymap.set('n', '<leader>fw', [[<Cmd>lua TelescopePicker('grep_string_cur_buf')<CR>]],	 		{desc = 'grep_string cur_buf'})
		vim.keymap.set('n', '<leader>fo', builtin.oldfiles, 		{desc = 'recent files'})                    -- recent files
		-- vim.keymap.set('n', '<leader>fb', builtin.buffers, 			{desc = 'buffer list'})                     -- buffer manager
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
		vim.keymap.set('n', '<leader>fH', telescope.extensions.helpgrep.helpgrep, {desc = 'help grep'})
	end
}
-- linrongbin16/fzfx.nvim : too slow starup loading / preview loading than telescope, and many errors in windows
