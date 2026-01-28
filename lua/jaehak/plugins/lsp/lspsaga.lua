return {
{
	-- improved lsp actions
	'nvimdev/lspsaga.nvim',
	event = 'LspAttach',
	opts = {
		symbol_in_winbar = {
			enable = false,
		},
		-- ////// code action : select behavior when diagnostics show //////////
		-- lspsaga show code action with
		code_action = { -- builtin lsp use line diagnostics / lspsaga use cursor diagnostics
			num_shortcut = true,
			extend_gitsigns = false, -- extend gitsign plugin diff action
		},
		-- ////// definition : peek_definition //////////
		definition = {
			keys = {
				edit = 'oo' ,  -- peek_definition is shown in floating window, when 'o' entered, go to the definition file
				vsplit = 'ov', -- open definition file in vsplit
				split = 'oh',  -- open definition file in horizontal split
				quit = 'q',
				close = '<C-c>k'
			}
		},
		-- ////// hover : library definition //////////
		hover = {					-- "KK" makes cursor move into hover window
			open_link = '<C-]>',   -- it can use website link also.
			open_cmd = '!chrome'
		},
		-- ////// outline : code tree //////////
		outline = {
			layout = 'float',
			detail = true,
		},
		-- ////// lightbulb : code action notify ////////
		lightbulb = {
			enable = false,		-- lightbulb makes screen shake, I don't know why
		},

	},
	keys = {
		-- gk : 1) lspsaga has strong advantage about peek_definition because it shows code_action together
		-- 		   but sometimes, lspsaga's peek_definition invokes error. I have to restart neovim after error
		-- 		2) lspsaga shows always one diagnostic even though there are multiple diagnostic in the line
		-- vim.keymap.set('n', 'go' , '<Cmd>Lspsaga outline<CR>'                   , {desc = 'outline', silent = true, noremap = true})
		{'K'      , '<Cmd>Lspsaga hover_doc<CR>'                 , desc = 'LSP - hover_doc'                 , silent = true, noremap = true},
		{'<C-S-K>', '<Cmd>Lspsaga hover_doc ++keep<CR>'          , desc = 'LSP - hover_doc ++keep'          , silent = true, noremap = true},
		{'gd'     , function ()
			if next(vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()})) then -- check lsp is attached to current buffer
				-- vim.lsp.buf.definition()
				vim.cmd('Lspsaga peek_definition')
			else
				vim.cmd('tag ' .. vim.fn.expand('<cword>'))
			end
		end, desc = 'LSP - peek_definition'           , silent = true, noremap = true},
		{'gt'     , '<Cmd>Lspsaga peek_type_definition<CR>'      , desc = 'LSP - peek_type_definition'      , silent = true, noremap = true},
		{'gk'     , function() vim.diagnostic.jump({count=1, float=true}) end, desc = 'LSP - diagnostics_jump_next'     , silent = true, noremap = true},
		{'gK'     , '<Cmd>Lspsaga show_workspace_diagnostics<CR>', desc = 'LSP - show_workspace_diagnostics', silent = true, noremap = true},
		-- Lspsaga rename() include all project files, not current buffer
		-- caution!!) lspsga has error for some lsp diagnostic
	},
},
{
	-- show code outline
	'Jaehaks/outline.nvim',
	keys = {
		{'go', '<Cmd>Outline<CR>', desc = 'LSP - Toggle outline'}
	},
	opts = {
		outline_window = {
			show_numbers = true,
			show_relative_numbers = true,
		},
		outline_items = {
			show_symbol_details = true,
			show_symbol_lineno = false,
		},
		symbol_folding = {
			autofold_depth = 1,
		},
		keymaps = {
			show_help = '?',
			close = {'<Esc>', 'q'},
			goto_location = '<S-CR>',
			goto_and_close = '<CR>',
			peek_location = 'o', -- highlight current node without goto
			restore_location = '<C-g>',
			hover_symbol = 'K',
			toggle_preview = '<C-Space>',
			rename_symbol = 'r',
			code_actions = 'a',
			fold = 'h',
			unfold = 'l',
			fold_all = 'W',
			unfold_all = 'E',
			fold_toggle = '<Tab>',
			fold_toggle_all = '<S-Tab>',
			fold_reset = 'R', -- restore folding state to the first opening time
			down_and_jump = '<C-k>', -- peek_location for lower item
			up_and_jump = '<C-j>', -- peek_location for upper item
		},
		providers = {
			lsp = {
				blacklist_clients = {'ltex'}
			}
		},
	}
},
{
	'Jaehaks/dropbar.nvim',
	enabled = true,
	event = 'LspAttach',
	opts = {
		bar = {
			enable = function(buf, win, _)
				buf = vim._resolve_bufnr(buf)         -- get current bufnr
				if not vim.api.nvim_buf_is_valid(buf) -- if current buffer is not valid, false
					or not vim.api.nvim_win_is_valid(win) then
					return false
				end

				if vim.fn.win_gettype(win) ~= '' -- if current window is not normal editor
					or vim.wo[win].winbar ~= ''  -- if winbar is open already
					or vim.bo[buf].ft == 'help' then -- if help
					return false
				end

				local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf)) -- if size is too large
				if stat and stat.size > 1024 * 1024 then
					return false
				end

				return not vim.tbl_isempty(vim.lsp.get_clients({ -- open winbar when only lsp is attached
							bufnr = buf,
							method = 'textDocument/documentSymbol',
						}))
			end,
			hover = false, -- highlight symbol under cursor, not work
			truncate = true, -- truncate winbar if it is too long
		}
	},
}
}
-- toggle term : must close using :q! not :q
-- lspsaga toggle term can use after lsp attatch only. and i will change to floatterm
-- ray-x/navigator.lua : change lsp action more comfortable. too complicate to I use...
-- stevearc/aerial.nvim : it shows only function
-- rachartier/tiny-code-action.nvim : it is exactly same with 'actions-preview.nvim'
-- 									  But the loading time is longer
-- 'RishabhRD/lspactions' : I don't know what is difference with native lsp handler
-- 							code_action has error
