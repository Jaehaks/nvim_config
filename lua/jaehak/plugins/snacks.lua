local picker_config = {
	matcher = {
		cwd_bonus = true,
	},
	ui_select = false,
	layout = {
		preset = 'vertical'
	},
	win = {
		input = { -- keys in normal mode
			keys = {
				['j'] = 'list_up',
				['k'] = 'list_down',
				['<c-j>'] = 'preview_scroll_up',
				['<c-k>'] = 'preview_scroll_down',
			}
		},
		list = {
			keys = {
				['j'] = 'list_up',
				['k'] = 'list_down',
				['<c-j>'] = 'preview_scroll_up',
				['<c-k>'] = 'preview_scroll_down',
			}
		}
	}
}

return {
	'folke/snacks.nvim',
	ft = {'dashboard'},
	event = 'User VimUISelect', -- when vim.ui.select() is called
	lazy = true,
	opts = {
		bigfile      = {enabled = false},
		dashboard    = {enabled = false},
		indent       = {enabled = false},
		input        = {enabled = false},
		picker       = picker_config,
		notifier     = {enabled = false},
		quickfile    = {enabled = false},
		scroll       = {enabled = false},
		statuscolumn = {enabled = false},
		words        = {enabled = false},
	},
	keys = {
		{ '<leader>fb', function () Snacks.picker.buffers({
			sort_lastused = false, -- sort by last used
		}) end, desc = 'Show buffer list', mode = {'n'}},

		{ '<leader>fc', function () Snacks.picker.command_history({
		}) end, desc = 'Show command history', mode = {'n'}},

		{ '<leader>fC', function () Snacks.picker.commands({
		}) end, desc = 'Show commands list', mode = {'n'}},

		{ '<leader>fd', function () Snacks.picker.diagnostics_buffer({
			sort = {
				fields = {'severity', 'file', 'lnum'} -- sort and show high severity at first
			},
			layout = {
				preset = 'vertical',
				layout = {
					width = 0.9,
				}
			}
		}) end, desc = 'Show diagnostics of current buffer', mode = {'n'}},

		{ '<leader>fD', function () Snacks.picker.diagnostics({
			-- sort cwd first than severity
			layout = {
				preset = 'vertical',
				layout = {
					width = 0.9,
				}
			}
		}) end, desc = 'Show diagnostics all of cwd', mode = {'n'}},

		{ '<leader>ff', function ()
			if Snacks.git.get_root() then -- if cwd is git directory
				Snacks.picker.git_files({ -- show files in git root
					untracked = true,
				})
			else
				Snacks.picker.files({ -- show files in cwd
					hidden = true,
					ignored = true,
				})
			end
		end, desc = 'Show files in git dir or cwd', mode = {'n'}},

		{ '<leader>fl', function () Snacks.picker.git_log_file()
		end, desc = 'Show git logs of current file', mode = {'n'}},

		{ '<leader>fL', function () Snacks.picker.git_log()
		end, desc = 'Show git logs of git directory', mode = {'n'}},

		{ '<leader>fg', function () Snacks.picker.lines({ -- is sorts by lnum
		}) end, desc = 'Show search results of current buffer', mode = {'n'}},

		{ '<leader>fG', function () Snacks.picker.grep({
			regex = false,
			show_empty = false,
			live = false,                -- It seems live search cannot give "or" result
			supports_live = true,
			need_search = false,
			dirs = {Snacks.git.get_root() or vim.fn.getcwd()},
			search = function (picker)
				if picker.visual then    -- if current mode is visual mode
					return picker:word() -- search the visual word
				else
					return ''            -- if normal mode, empty search
				end
			end
		}) end, desc = 'Show grep result under root', mode = {'n', 'v'}},

		{ '<leader>fh', function () Snacks.picker.help()
		end, desc = 'Show help tags', mode = {'n'}},

		{ '<leader>fe', function () Snacks.picker.highlights()
		end, desc = 'Show higlight', mode = {'n'}},

		{ '<leader>fi', function () Snacks.picker.icons()
		end, desc = 'Show nerd icons', mode = {'n'}},

		{ '<leader>fj', function () Snacks.picker.jumps()
		end, desc = 'Show jump list', mode = {'n'}},

		{ '<leader>fk', function () Snacks.picker.keymaps({
			win = {
				input = {
					keys = {
						["<a-g>"] = { "toggle_global", mode = { "n", "i" }, desc = "Toggle Global Keymaps" },
						["<a-b>"] = { "toggle_buffer", mode = { "n", "i" }, desc = "Toggle Buffer Keymaps" },
					},
				},
			},
		})
		end, desc = 'Show keymaps', mode = {'n'}},

		{ '<leader>fm', function () Snacks.picker.jumps()
		end, desc = 'Show marks', mode = {'n'}},

		{ '<leader>fo', function () Snacks.picker.recent({
			sort = {
				fields = {'time:desc'}
			},
			filter = {
				[vim.fn.stdpath('data')] = false,
			}
		}) end, desc = 'Show oldfiles', mode = {'n'}},

		{ '<leader>fu', function () Snacks.picker.undo({
		}) end, desc = 'Show undo list', mode = {'n'}},

		{ '<leader>fz', function () Snacks.picker.zoxide({
		}) end, desc = 'Show files using zoxide', mode = {'n'}},
	}
	-- cliphist() doesn't work in windows
	-- icons : show nerd icons
}
