return {
{
	-- improved lsp actions
	'nvimdev/lspsaga.nvim',
	event = 'LspAttach',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons'
	},
	config = function ()
		require('lspsaga').setup({
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
		})
		-- vim.keymap.set('n', 'go'     , '<Cmd>Lspsaga outline<CR>'                   , {desc = 'outline', silent = true, noremap = true})
		vim.keymap.set('n', 'K'      , '<Cmd>Lspsaga hover_doc<CR>'                 , {desc = 'LSP - hover_doc', silent = true, noremap = true})
		vim.keymap.set('n', '<C-S-K>', '<Cmd>Lspsaga hover_doc ++keep<CR>'          , {desc = 'LSP - hover_doc ++keep', silent = true, noremap = true})
		vim.keymap.set('n', 'gd'     , '<Cmd>Lspsaga peek_definition<CR>'           , {desc = 'LSP - peek_definition', silent = true, noremap = true})
		vim.keymap.set('n', 'gt'     , '<Cmd>Lspsaga peek_type_definition<CR>'      , {desc = 'LSP - peek_type_definition', silent = true, noremap = true})
		vim.keymap.set('n', 'gk'     , '<Cmd>Lspsaga diagnostic_jump_next<CR>'      , {desc = 'LSP - diagnostics_jump_next', silent = true, noremap = true})
		vim.keymap.set('n', 'gK'     , '<Cmd>Lspsaga show_workspace_diagnostics<CR>', {desc = 'LSP - show_workspace_diagnostics', silent = true, noremap = true})
		-- Lspsaga rename() include all project files, not current buffer
	end
	-- caution!!) lspsga has error for some lsp diagnostic
},
{
	-- show signature help when enter functions
	'ray-x/lsp_signature.nvim',
	enabled = true,
	event = 'LspAttach',
	config = function ()
		local lsp_sig = require('lsp_signature')
		local cfg = {
			doc_lines = 100,           -- line length to fetch document
			max_height = 12,           -- line length to show floating window
			hint_enable     = false,   -- hint_inline option does not work
			toggle_key      = '<C-s>', -- turn off signature help temporary in insert mode
			move_cursor_key = '<C-w>', -- go to signature help window in insert mode (in normal mode, use <C-w>w)
		}
		lsp_sig.setup(cfg)
		lsp_sig.on_attach(cfg) -- it is deprecated, but it need to lsp_signature automatically, i don't know why

		vim.keymap.set({ 'n' }, '<C-s>', lsp_sig.toggle_float_win , {silent = true, noremap = true, desc = 'LSP - toggle signature help'})
	end
},
{
	-- show code outline
	'hedyhli/outline.nvim',
	lazy = true,
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
	'aznhe21/actions-preview.nvim',
	lazy = true,
	event = 'LspAttach',
	config = function ()
		local ap = require('actions-preview')
		ap.setup({
			telescope = {
				sorting_strategy = "ascending",
				layout_strategy = "vertical",
				layout_config = {
					width = 0.8,
					height = 0.5,
					prompt_position = "top",
					preview_cutoff = 20,
					preview_height = function(_, _, max_lines)
						return max_lines - 15
					end,
					},
				},
		})
		vim.keymap.set({'n', 'v'}, 'ga', function ()
			vim.diagnostic.goto_next() -- move cursor to diagnostics location
			ap.code_actions()           -- code_actions() execute only current cursor location
		end , {noremap = true, desc = 'LSP - action-preview'})
	end

}
}
-- toggle term : must close using :q! not :q
-- lspsaga toggle term can use after lsp attatch only. and i will change to floatterm
-- ray-x/navigator.lua : change lsp action more comfortable. too complicate to I use...
-- stevearc/aerial.nvim : it shows only function
