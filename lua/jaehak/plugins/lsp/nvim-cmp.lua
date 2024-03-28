return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',		-- load before starting insert mode / replace mode
	init = function ()
		-- spell must be true to use cmp-spell
		-- changing these option must be out of config function of nvim-cmp
		-- I have no idea what is the reason, but something turns off this option after setting option
		vim.opt.spell = true
		vim.opt.spelllang = {'en_us'}
	end,
	dependencies = {
		'hrsh7th/cmp-buffer',       -- source for text in buffer
		'hrsh7th/cmp-path',         -- source for file system path
		'hrsh7th/cmp-cmdline',		-- source for commandline 
		'hrsh7th/cmp-nvim-lsp',     -- using LSP for source
		'f3fora/cmp-spell',			-- source for vim's spellsuggest
		'L3MON4D3/LuaSnip',         -- snippet engine
		'saadparwaiz1/cmp_luasnip', -- using LuaSnip for source
		'mstanciu552/cmp-matlab'    -- source of matlab

	},
	config = function()
		local cmp = require('cmp')
		local compare = require('cmp.config.compare')
		local context = require('cmp.config.context')
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
				['<C-n>'] = cmp.mapping.complete(),
			    ['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then -- select next cmp item when visible
						cmp.select_next_item()
					elseif ls.expand_or_locally_jumpable() then -- jump next node in snippet region 
						ls.jump(1)
					else
						fallback()
					end
			    end, {'i', 's'}),
			    ['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif ls.expand_or_locally_jumpable() then
						ls.jump(-1)
					else
						fallback()
					end
			    end, {'i', 's'}),
				['<C-e>'] 	= cmp.mapping.close(),
				['<CR>']	= cmp.mapping.confirm({select = true,}),
					-- select:true => select first item if you didn't select any item
			}),
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
			sorting = {
				priority_weight = 1.0,
				comparators = {
					compare.score, -- for spell check
					compare.recently_used,
					compare.locality,
					compare.kind,
					compare.offset,
					compare.order,
					compare.length,
					compare.exact,
				}
			}
		})

		-- cmd.setup.filetype overwrites default source settings, not added
		-- /////// source of matlab
		cmp.setup.filetype({'matlab'}, {
			sources = {
				{name = 'luasnip', group_index = 1, max_item_count = 5},
				{name = 'spell', group_index = 1, max_item_count = 2,	-- useless under 2nd suggestion
					option = {
						keep_all_entries = true, -- it can show more possible list
						enable_in_context = function () -- is_available() does not work, this option make spell completion work only 
							return context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
						end
					}
				},
				{name = 'cmp_matlab', group_index = 1, max_item_count = 5},
				{name = 'buffer', group_index = 1, max_item_count = 5},
				{name = 'nvim_lsp', group_index = 2, max_item_count = 5},
			}
		})

		-- /////// source of lua
		cmp.setup.filetype({'lua'}, {
			sources = {
				{name = 'luasnip', group_index = 1, max_item_count = 5},
				{name = 'spell', group_index = 1, max_item_count = 2,	-- useless under 2nd suggestion
					option = {
						keep_all_entries = true, -- it can show more possible list
						enable_in_context = function () -- is_available() does not work, this option make spell completion work only 
							return context.in_treesitter_capture('comment') or context.in_syntax_group('Comment')
						end
					}
				},
				{name = 'nvim_lsp', group_index = 1, max_item_count = 5},
				{name = 'buffer', group_index = 1, max_item_count = 5},
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
				{name = 'path', group_index = 1},
				{name = 'cmdline', group_index = 2}
			}
		})

		vim.opt.pumheight = 10			-- maximum item number when show completion

--		local capabilities = require('cmp_nvim_lsp').default_capabilities()
--		require('lspconfig').lua_ls.setup({
--			capabilities = capabilities
--		})
	end,
}

