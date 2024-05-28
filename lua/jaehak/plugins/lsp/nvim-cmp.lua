return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',		-- load before starting insert mode / replace mode
	init = function ()
		-- spell must be true to use cmp-spell
		-- changing these option must be out of config function of nvim-cmp
		-- I have no idea what is the reason, but something turns off this option after setting option
		vim.opt.spell = true
		vim.opt.spelllang = {'en_us'}
		vim.opt.pumheight = 10			-- maximum item number when show completion
	end,
	dependencies = {
		'hrsh7th/cmp-buffer',       -- source for text in buffer
		'hrsh7th/cmp-path',         -- source for file system path
		'hrsh7th/cmp-cmdline',		-- source for commandline, [command], [path]
		'hrsh7th/cmp-nvim-lsp',     -- using LSP for source
		'f3fora/cmp-spell',			-- source for vim's spellsuggest
		'L3MON4D3/LuaSnip',         -- snippet engine
		'saadparwaiz1/cmp_luasnip', -- using LuaSnip for source
		'mstanciu552/cmp-matlab',   -- source of matlab
		{
			-- BUG: if cmp-vimtex was configured, the source attached repeatedly
			-- if I don't use lazy-loading, the duplicate is removed. but I have to load this plugin every opening (200ms load time)
			'micangl/cmp-vimtex', 		-- source of vimtex for latex
		},
	},
	config = function()
		local cmp = require('cmp')
		local compare = require('cmp.config.compare')
		local context = require('cmp.config.context')
		-- local types = require('cmp.types')
		local ls = require('luasnip')

		-- //// nvim-cmp configuration ////////
		require('luasnip.loaders.from_vscode').lazy_load()
		cmp.setup({
			completion = {
				-- noselect : do not select a match in the menu 
				completeopt = 'menu, menuone, preview, noselect',
				keyword_length = 2,
			},
			preselect = cmp.PreselectMode.None, --  do not preselect item
			performance = {
				max_view_ertries = 10, -- can it reduce load delay?
			},
			window = {
				-- make the completion window bordered
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			matching = {
				-- disable fuzzy-related matching completion
				disallow_fuzzy_matching = true,
				disallow_fullfuzzy_matching = true,
				disallow_partial_fuzzy_matching = true,
				disallow_partial_matching = false,
				disallow_prefix_unmatching = false,
			},
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- expand snippet autocomplete in lsp with snippet engine
				end,
			},
			mapping = cmp.mapping.preset.insert({
			    ['<TAB>'] = cmp.mapping(function(fallback)
					if cmp.visible() then -- select next cmp item when visible
						cmp.select_next_item()
					else
						fallback()
					end
			    end, {'i', 's'}),
			    ['<S-TAB>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
			    end, {'i', 's'}),
				['<C-p>'] = cmp.mapping(function (fallback)
					if ls.expand_or_locally_jumpable() then
						ls.jump(1)
					elseif ls.expandable() then
						ls.expand()
					else
						fallback()
					end
				end, {'i', 's'}),
				['<C-S-p>'] = cmp.mapping(function (fallback)
					if ls.expand_or_locally_jumpable() then
						ls.jump(-1)
					elseif ls.expandable() then
						ls.expand()
					else
						fallback()
					end
				end, {'i', 's'}),
				['<c-n>'] = cmp.mapping(function (fallback) -- remain showing previous deleting keymap
					if cmp.visible() then
						cmp.mapping.close()
					else
						fallback()
					end
				end),
				['<C-e>'] 	= cmp.mapping(function (fallback) -- disable default <C-e> mapping to separate with deleting keymap
					fallback()
				end),
				['<CR>']	= cmp.mapping(function (fallback) -- In cmp.mapping, function have to be called without <mapping> field
					if cmp.visible() then                     -- without this condition, cmp.abort() will be execute multiple times
						if cmp.get_active_entry() == nil then -- if you don't select, <cr> operate as original function
							cmp.abort()
							vim.api.nvim_input('<cr>')
						else                                  -- if you select, <cr> means complete
							cmp.confirm({select = false})     -- select:true => select first item if you didn't select any item
						end
					else
						fallback()                            -- if cmp not visible, <cr> operate as original function
					end
				end, {'i', 's'}),
			}),
			formatting = { -- completion display
				fields = {'abbr', 'kind', 'menu'}, -- set field order in completion window
				format = function (entry, item)

					local menu_icon = {
						nvim_lsp   = '[LSP]',
						luasnip    = '[LuaSnip]',
						buffer     = '[BUF]',
						path       = '[PATH]',
						cmp_matlab = '[MATLAB]',
						spell      = '[SPELL]',
						cmdline    = '[CMD]',
						vimtex     = item.menu, -- show packages as menu
					}
					item.menu = menu_icon[entry.source.name] -- change kind field

					-- item.dup make items unique if there are duplicated abbr. 
					-- but it does not mean sources are not duplicated

					return item
				end
			},
			sorting = {
				priority_weight = 1.0,
				comparators = {
					compare.recently_used,
					compare.locality,
					compare.order, -- to order of spellsuggest for cmp-spell
				}
			},
			sources = cmp.config.sources({
				{
					name = 'spell',
					max_item_count = 3,	-- useless under 2nd suggestion + first one is the same with input
					priority = 1000,
					option = {
						keep_all_entries = true, -- it can show more possible list
						enable_in_context = function () -- is_available() does not work, this option make spell completion work only 
							return context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
						end,
						preselect_correct_word = false, -- if false, order is the same with spellsuggest()
					},
				},
				{
					name = 'buffer',
					max_item_count = 5,
					priority = 500,
				},
				{
					name = 'luasnip',
					max_item_count = 5,
					priority = 250,
					-- show_autosnippets : it true, show autosnip, but it is expanded automatically when word selected in cmp window
				},
				{
					name = 'nvim_lsp',
					max_item_count = 5,
					priority = 250,
				},
				{
					name = 'path',
					priority = 100,
				},
			},{
				-- TBD:
			}),
		})

		-- cmd.setup.filetype overwrites default source settings, not added
		-- /////// source of matlab
		cmp.setup.filetype({'matlab'}, {
			sources = cmp.config.sources({
				{
					name = 'spell',
					max_item_count = 3,	-- useless under 2nd suggestion + first one is the same with input
					priority = 1000,
					option = {
						keep_all_entries = true, -- it can show more possible list
						enable_in_context = function () -- is_available() does not work, this option make spell completion work only 
							return context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
						end,
						preselect_correct_word = false, -- if false, order is the same with spellsuggest()
					},
				},
				{
					name = 'buffer',
					max_item_count = 5,
					priority = 500,
				},
				{
					name = 'luasnip',
					max_item_count = 5,
					priority = 250,
				},
				{
					name = 'cmp_matlab',
					max_item_count = 5,
					priority = 250,
				},
				{
					name = 'nvim_lsp',
					max_item_count = 5,
					priority = 250,
				},
				{
					name = 'path',
					priority = 100,
				},
			},{
				-- TBD:
			}),
		})

		-- /////// source of plain text
		cmp.setup.filetype({'markdown', 'text', 'oil', 'NeogitCommitMessage'}, {
			sources = cmp.config.sources({
				{
					name = 'spell',
					max_item_count = 3,	-- useless under 2nd suggestion + first one is the same with input
					priority = 1000,
					option = {
						keep_all_entries = true, -- it can show more possible list
					},
					preselect_correct_word = false, -- if false, order is the same with spellsuggest()
				},
				{
					name = 'buffer',
					max_item_count = 5,
					priority = 500,
				},
				{
					name = 'path',
					priority = 250,
				},
			},{
				-- TBD:
			}),
		})

		-- /////// source of latex using vimtex
		cmp.setup.filetype({'tex'}, {
			sources = cmp.config.sources({
				{
					name = 'luasnip',
					max_item_count = 5,
					priority = 1000,
				},
				{
					name = 'vimtex',
					priority = 500,
				},
			},{
				{
					name = 'spell',
					max_item_count = 3,	-- useless under 2nd suggestion + first one is the same with input
					priority = 500,
					option = {
						keep_all_entries = true, -- it can show more possible list
					},
					preselect_correct_word = false, -- if false, order is the same with spellsuggest()
				},
				{
					name = 'buffer',
					max_item_count = 5,
					priority = 500,
				},
			}),
		})

		-- /////////`/` cmdline setup. (search)
		cmp.setup.cmdline('/', {
			mapping = cmp.mapping.preset.cmdline(),
			sources ={
				{name = 'buffer', group_index = 1, max_item_count = 5},
			}
		})

		-- /////////`:` cmdline setup. (command)
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources ={
				-- {name = 'path', group_index = 1}, -- it supports path starting with slash (./, ../), but don't support windows drive
				{name = 'cmdline', group_index = 2} -- it supports path also starting with backslash and windows drive (ex. c:\Users)
			}
		})

	end,
}

