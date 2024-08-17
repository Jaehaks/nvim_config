local paths = require('jaehak.core.paths')
return {
	-- lir.nvim : very simple and good to operate, but i think oil.nvim is more expandable
	-- 			  if current file name change, the change not apply to buffer name immediately
{
	'stevearc/oil.nvim',
	enabled = true,
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'SirZenith/oil-vcs-status', -- use default config
	},
	config = function ()
		local oil = require('oil')
		oil.setup({
			default_file_explorer = false,
			columns = {
				'icon',
				{'size', highlight = 'NightflyPurple'},
				{'mtime', highlight = 'NightflyGreen', format = '%F %H:%M:%S' }		-- modified date, format 2024-03-10 18:00
			},
			buf_options = {
				buflisted = true,
				bufhidden = 'hide',
			},
			win_options ={
				signcolumn = 'yes:2', 		-- oil-git-status.nvim
				wrap = false,
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			float = {
				override = function(conf)
					conf.relative = 'editor'
					conf.width = math.floor(vim.o.columns * 0.9)
					conf.height = math.floor(vim.o.lines * 0.5)
					conf.row = 2
					conf.col = 3
					conf.border = 'double'
					return conf
				end,
			},
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,	-- skip confirmation popup
			prompt_save_on_select_new_entry = true,
			cleanup_delay_ms = 0,		-- delete oil buffer immediately after close
			lsp_file_methods = {
				timeout_ms = 1000,
				autosave_changes = false,
			},
			keymaps = {
				["g?"]    = "actions.show_help",
				["gs"]    = "actions.change_sort",
				["gx"]    = "actions.open_external",
				["g."]    = "actions.toggle_hidden",
				["g\\"]   = "actions.toggle_trash",
				["<C-l>"] = "actions.select",
				["<CR>"]  = "actions.select",
				["<C-v>"] = "actions.select_vsplit",
				["<C-x>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<Tab>"] = "actions.preview", -- it does not support with floating window
				["q"]     = "actions.close",
				["<F5>"]  = "actions.refresh",
				["<C-h>"] = "actions.parent",
				["_"]     = "actions.open_cwd",		-- come back to cwd (current cd)
				["`"]     = "actions.cd",
				["~"]     = "actions.tcd",
			},
			use_default_keymaps = false,
			view_options= {
				show_hidden = true,
				sort = {
					{'type', 'asc'},	-- firstly, sort by type ascending
					{'name', 'asc'},	-- secondly, sort by name ascending
				}
			}
		})


		-- open current buffer directory
		vim.keymap.set('n', '<leader>ee', oil.open_float, {desc = 'open current buffer dir'}) -- default current buffer cwd

		-- open config directory
		vim.keymap.set('n', '<leader>ec', function () -- default current buffer cwd
			-- require('oil').open_float(vim.fn.stdpath("config") .. "\\lua\\jaehak\\plugins")
			require('oil').open_float(paths.nvim.config)
		end, {desc = 'open nivm-config dir'}) 

		-- open data directory
		vim.keymap.set('n', '<leader>ed', function () 
			require('oil').open_float(paths.nvim.data)
		end, {desc = 'open nvim-data dir'}) 

		-- open note directory
		vim.keymap.set('n', '<leader>en', function () 
			require('oil').open_float(paths.obsidian.personal)
		end, {desc = 'open note dir(personal)'}) 

		-- local keymap for oil
		local User_Oil = vim.api.nvim_create_augroup('User_Oil', {clear = true})
		vim.api.nvim_create_autocmd('FileType', {
			group = User_Oil,
			pattern = 'oil',
			callback = function ()
				vim.keymap.set('n', '<C-j>', '<Up>', {buffer = 0, noremap = true, desc = 'Up in Oil'})
				vim.keymap.set('n', '<C-k>', '<Down>', {buffer = 0, noremap = true, desc = 'Down in Oil'})
			end
		})
	end

},
}
-- 'refractalize/oil-git-status.nvim' : autocmd error is invoked whenever i write some file in oil.
-- 									    it dosn't show git sign. I think it has some bug in windows




