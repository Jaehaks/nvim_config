local paths = require('jaehak.core.paths')
return {
	-- lir.nvim : very simple and good to operate, but i think oil.nvim is more expandable
	-- 			  if current file name change, the change not apply to buffer name immediately
{
	"mikavilpas/yazi.nvim",
	enabled = false,
	lazy = true,
	ft = {'dashboard'},
	keys = {
		{'<leader>ee', function () require('yazi').yazi(nil, vim.fn.getcwd()) end                     , desc = 'Open yazi at current buffer dir'},
		{'<leader>ec', function () require('yazi').yazi(nil, paths.nvim.config) end      , desc = 'Open yazi at nvim-config dir'},
		{'<leader>ed', function () require('yazi').yazi(nil, paths.nvim.data) end        , desc = 'Open yazi at nvim-data dir'},
		{'<leader>en', function () require('yazi').yazi(nil, paths.obsidian.personal) end, desc = 'Open yazi at note dir(personal)'},
	},
	init = function ()
		vim.g.loaded_netrwPlugin = 1
	end,
	opts = {
		open_for_directories = true, -- open yazi instead of netrw (call yazi.setup())
		keymaps = {
			show_help                            = '<f1>',
			open_file_in_vertical_split          = '<c-v>',
			open_file_in_horizontal_split        = '<c-x>',
			open_file_in_tab                     = '<c-t>',
			grep_in_directory                    = '<c-f>', -- using telescope's live_grep
			replace_in_directory                 = false, -- using grug-far
			cycle_open_buffers                   = false, -- (not work)
			copy_relative_path_to_selected_files = false,-- require GNU realpath andgrealpath (not work)
			send_to_quickfix_list                = false,
		},
		clipboard_register = '+',
	},
},
{
	'stevearc/oil.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'refractalize/oil-git-status.nvim',
		'JezerM/oil-lsp-diagnostics.nvim',
	},
	lazy = true,
	ft = {'dashboard'},
	keys = {
		{'<leader>ee', function () require('oil').open_float() end,                        desc = 'Open Oil Explorer (cwd)'},
		{'<leader>ec', function () require('oil').open_float(paths.nvim.config) end,       desc = 'Open Oil Explorer (config)'},
		{'<leader>ed', function () require('oil').open_float(paths.nvim.data) end,         desc = 'Open Oil Explorer (data)'},
		{'<leader>en', function () require('oil').open_float(paths.obsidian.personal) end, desc = 'Open Oil Explorer (personal)'},
	},
	config = function ()
		vim.api.nvim_set_hl(0, "OilSize"     , {fg = "#32CD32"})
		vim.api.nvim_set_hl(0, "OilMtime"     , {fg = "#FFC72C"})

		require('oil').setup({ -- setup() in config field with opts argument has unknown error.
			columns = {
				'icon',
				{'size', highlight = 'OilSize'},
				{'mtime', highlight = 'OilMtime', format = '%Y-%m-%d %T' },
			},
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			view_options = {
				show_hidden = true,
			},
			win_options = {
				signcolumn = 'yes:2',
			},
		})

		require('oil-git-status').setup({}) -- oil-git-status setup must be called after 'oil' loading
		require('oil-lsp-diagnostics').setup({})
	end,
}
}
-- 'stevearc/oil.nvim', : it was very nice file manager, but file deletion with trash-cli cannot works anymore.
-- 						  so I need to replace it to yazi
-- 'refractalize/oil-git-status.nvim' : autocmd error is invoked whenever i write some file in oil.
-- 									    it dosn't show git sign. I think it has some bug in windows
-- "mikavilpas/yazi.nvim", : After yazi update, it has so many bugs to open explorer. I cannot use it anymore...




