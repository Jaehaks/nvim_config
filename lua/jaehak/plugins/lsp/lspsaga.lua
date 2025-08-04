return {
{
	-- improved lsp actions
	'nvimdev/lspsaga.nvim',
	event = 'LspAttach',
	opts = {
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
				vim.lsp.buf.definition()
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
	-- show signature help when enter functions
	'ray-x/lsp_signature.nvim',
	enabled = false, -- it will be replaced with blink.cmp's feature
	event = 'InsertEnter',
	keys = {
		{'<C-s>', function() require('lsp_signature').toggle_float_win() end, silent = true, noremap = true, desc = 'LSP - toggle signature help' }
	},
	opts = {
		doc_lines = 100,           -- line length to fetch document
		max_height = 12,           -- line length to show floating window
		hint_enable     = false,   -- hint_inline option does not work
		toggle_key      = '<C-s>', -- turn off signature help temporary in insert mode
		move_cursor_key = '<C-w>', -- go to signature help window in insert mode (in normal mode, use <C-w>w)

		bind = true,
		floating_window_off_x = -100,
		floating_window_off_y = 100,
	},
	config = function (_, opts)
		local lsp_sig = require('lsp_signature')
		lsp_sig.setup(opts )
		lsp_sig.on_attach(opts) -- it is deprecated, but it need to lsp_signature automatically, i don't know why

	end
},
{
	-- show code outline
	'hedyhli/outline.nvim',
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
	-- archived
	'luckasRanarison/clear-action.nvim',
	enabled = false,
	keys = {
		{
			'ga',
			-- keymap : first detect code action under cursor and go to next code action if it doesn't exist
			-- if code action doesn't supports, just show diagnostic
			function ()
				---@type { textDocument: { uri: string }, range: lsp.Range, context?: lsp.CodeActionContext }
				local params = vim.lsp.util.make_range_params(nil, 'utf-8') -- create range parameter at cursor to lsp request
				-- after make_range_params(), params has only {textDocument, range},
				-- context is added to params to include diagnostics of current line
				params.context = { diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 }) }
				-- require code action to all lsp server (buf_request_all)
				-- vim.lsp.buf_request_all(0, 'textDocument/codeAction', params, function(err, results, _)
				vim.lsp.buf_request_all(0, 'textDocument/codeAction', params, function(results)
					local all_actions = {}
					local has_action = false

					for _, res in pairs(results) do
						if res.error then
							vim.api.nvim_echo({{'CodeActionError : ' .. res.error.message}}, true, {err = true})
						elseif res.result and not vim.tbl_isempty(res.result) then
							for _, action in ipairs(res.result) do
								table.insert(all_actions,action)
							end
							has_action = true
						end
					end

					if not has_action then
						vim.diagnostic.jump({count=1, float=true})
					else
						require('clear-action.actions').code_action({context = params.context, actions = all_actions})
					end
				end)
			end,
			desc = 'Code action or go to next diagnostic',
		}
	},
	opts = {
		signs = {
			enable = false,
		},
		popup = {
			enable = true,
			hide_cursor = false,
		},
	},
	config = function ()
		-- keymap : quit code action if window of code action is opened
		-- set the autocmd in config() for function define at once
		local User_codeAction = vim.api.nvim_create_augroup('User_codeAction', {clear = true})
		vim.api.nvim_create_autocmd('FileType', {
			group = User_codeAction,
			pattern = 'CodeAction',
			callback = function (args)
				vim.keymap.set('n', 'ga', function ()
					-- vim.api.nvim_command(':q') -- quit window
					vim.cmd('q')
					vim.diagnostic.jump({count=1, float=true})
					require('clear-action.actions').code_action()
				end, {buffer = args.buf, desc = 'quit and code action next'}) -- get buffer number dynamically
			end
		})
	end
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
