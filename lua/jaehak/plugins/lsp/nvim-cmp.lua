return {
	'hrsh7th/nvim-cmp',
--	enabled = false,
	event = 'InsertEnter',		-- load before starting insert mode / replace mode
	dependencies = {
		'hrsh7th/cmp-buffer',			-- source for text in buffer
		'hrsh7th/cmp-path',				-- source for file system path
		'hrsh7th/cmp-nvim-lsp',
		'L3MON4D3/LuaSnip',				-- snippet engine
		'saadparwaiz1/cmp_luasnip',		-- for autocompletion
		'windwp/nvim-autopairs',		-- autopairs
	},
	config = function()
		local cmp = require('cmp')

		require('luasnip.loaders.from_vscode').lazy_load()

		cmp.setup({
			completion = {
				-- noselect : do not select a match in the menu 
				completeopt = 'menu, menuone, preview, noselect',
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
					require('luasnip').lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-Space>'] 	= cmp.mapping.complete(),
				['<Tab>']		= cmp.mapping.select_next_item(),
				['<S-Tab>']		= cmp.mapping.select_prev_item(),
				['<C-e>'] 		= cmp.mapping.abort(),
				['<CR>']		= cmp.mapping.confirm({select = false}),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp'},
				{ name = 'luasnip' },	-- snippets
				{ name = 'buffer' }, 	-- text within current buffer
				{ name = 'path'	}, 		-- file system path
			}),
		})

		vim.opt.pumheight = 15			-- maximum item number when show completion

		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		require('lspconfig').lua_ls.setup({
			capabilities = capabilities
		})
	end,
}

