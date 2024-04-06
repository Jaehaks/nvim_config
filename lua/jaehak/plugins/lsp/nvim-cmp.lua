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
				['<c-n>'] = cmp.mapping.complete(),
			    ['<tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then -- select next cmp item when visible
						cmp.select_next_item()
					elseif ls.expand_or_locally_jumpable() then -- jump next node in snippet region 
						ls.jump(1)
					else
						fallback()
					end
			    end, {'i', 's'}),
			    ['<s-tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif ls.expand_or_locally_jumpable() then
						ls.jump(-1)
					else
						fallback()
					end
			    end, {'i', 's'}),
				['<c-e>'] 	= cmp.mapping.close(),
				['<cr>']	= cmp.mapping(function (fallback) -- In cmp.mapping, function have to be called without <mapping> field
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
						cmdline    = '[CMD]'
					}
					item.menu = menu_icon[entry.source.name] -- change kind field
					return item
				end
			},
			sorting = {
				priority_weight = 2.0,
				comparators = {
					-- compare.exact,
					-- compare.recently_used,
					-- compare.locality,
					-- compare.length
					-- compare.score, -- for spell check
					-- compare.recently_used,
					-- compare.locality,
					-- compare.kind,
					-- compare.offset,
					compare.order,
					-- compare.sort_text
					compare.exact,
				}
			},
			sources = cmp.config.sources(	-- default source which has not identify filetype
			{ -- group index = 1
				{
					name = 'path',
					max_item_count = 5,
				},
				{
					name = 'spell',
					max_item_count = 2,
					option = {
						keep_all_entries = true, -- it can show more possible list
					}
				},
				{
					name = 'buffer',
					max_item_count = 5,
				},
			}),
		})

		-- cmd.setup.filetype overwrites default source settings, not added
		-- /////// source of matlab
		cmp.setup.filetype({'matlab'}, {
			sources = {
				{name = 'luasnip', group_index = 1, max_item_count = 5},
				{name = 'cmp_matlab', group_index = 1, max_item_count = 5},
				{name = 'buffer', group_index = 1, max_item_count = 5},
				{name = 'spell', group_index = 1, max_item_count = 2,	-- useless under 2nd suggestion
					option = {
						keep_all_entries = true, -- it can show more possible list
						enable_in_context = function () -- is_available() does not work, this option make spell completion work only 
							return context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
						end
					}
				},
				{
					name = 'nvim_lsp',
					group_index = 2,
					max_item_count = 5,
					-- entry_filter = function(entry, ctx) -- it dosen't work
					-- 	if entry.get_kind() == 15 then
					-- 		return false
					-- 	end
					-- end
				},
			}
		})

		-- /////// source of lua
		cmp.setup.filetype({'lua'}, {
			sources = {
				-- {name = 'luasnip', group_index = 1, max_item_count = 5},
				-- {
				-- 	name = 'nvim_lsp',
				-- 	group_index = 1,
				-- 	max_item_count = 5,
				-- },
				-- {name = 'buffer', group_index = 1, max_item_count = 5},
				{name = 'spell', group_index = 1, -- max_item_count = 2,	-- useless under 2nd suggestion
					option = {
						keep_all_entries = true, -- it can show more possible list
						enable_in_context = function () -- is_available() does not work, this option make spell completion work only 
							return context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
						end
					}
				},
				-- 
				-- overshot
			}
		})

		-- /////// source of markdown 
		cmp.setup.filetype({'markdown', 'text'}, {
			sources = {
				{name = 'buffer', max_item_count = 5},
				{name = 'spell', group_index = 1, max_item_count = 2,	-- useless under 2nd suggestion
					option = {
						keep_all_entries = true, -- it can show more possible list
					}
				},
				{name = 'path', max_item_count = 5},
			}
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
				-- {name = 'path', group_index = 1},
				{name = 'cmdline', group_index = 2}
			}
		})

	end,
}

