-- check https://github.com/latex-lsp/texlab/wiki/LSP-Internals#enum-mapping
local CompletionItemKind_texlab = {
    'String',
    'Float',
    'Command',
    'Label',
    'Field',
    'Theorem',
    'Package/Class',
    'Misc',
    'Section',
    'Library',
    'Thesis',
    'Command_args',
    'Environment',
    'Keyword',
    'Snippet',
    'Color',
    'File',
    'Reference',
    'Folder',
    'EnumMember',
    'Equation',
    'Book',
    'Article',
    'Part',
    'Collection',
}

return {
	'saghen/blink.cmp',
	event = 'InsertEnter',
	version = '*', -- recent release
	dependencies = {
		'moyiz/blink-emoji.nvim',
		'ribru17/blink-cmp-spell',
		'L3MON4D3/LuaSnip',
		'saghen/blink.compat',
		'Kaiser-Yang/blink-cmp-git', -- needs `gh` or `curl`
		'xieyonn/blink-cmp-dat-word',
		'erooke/blink-cmp-latex',
	},
	opts =  {
		keymap = { -- Applied only completion menu
			preset = 'none',
			['<Tab>']   = { 'select_next', 'fallback_to_mappings' },
			['<S-Tab>'] = { 'select_prev', 'fallback_to_mappings' },
			['<C-n>']   = { 'snippet_forward', 'fallback' }, -- for choice mode
			['<C-S-n>'] = { 'snippet_backward', 'fallback' }, -- for choice mode
			['<C-p>'] = {
				function(cmp)
					if require('luasnip').expand_or_locally_jumpable() then
						vim.schedule(function()
							return require('luasnip.extras.select_choice')()
						end)
						return true
					else
						return cmp.snippet_forward()
					end
				end,
				'fallback',
			},
			['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
			['<C-q>'] = { 'hide' },
			-- ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
			['<CR>'] = { 'accept', 'fallback', },
			-- BUG: fallback() for <CR> cannot return to behavior of require('mini.pairs').cr(). so we treat like above
			-- BUG: <C-Space> doesn't work
		},
		appearance = { nerd_font_variant = 'mono' },
		completion = {
			keyword = { range = 'prefix' },
			list = {
				selection = {
					preselect = false, -- don't select first when menu is shown
				}
			},
			menu = {
				draw = {
					columns = {
						{'kind_icon'},
						{'label', 'label_description', gap = 1},
						{'kind'}, 		 -- show categories of item
						{'source_name'}, -- show source_name in menu
					},
				}
			},
			documentation = { -- show definition of completion list
				auto_show = false
			},
		},

		signature = {
			enabled = true, -- show signature help
		},
		fuzzy = {
			implementation = 'prefer_rust_with_warning',
		},
		snippets = {preset = 'luasnip'}, -- use luasnip for `snippets` engine
		sources = {
			min_keyword_length = 2,
			default = {'snippets', 'lsp', 'buffer', 'datword', 'spell', 'path', 'cmdline'},
			per_filetype = {
				lua       = {'lazydev', 'snippets', 'lsp', 'buffer', 'datword', 'spell', 'path'},
				matlab    = {'snippets', 'lsp', 'buffer', 'datword', 'spell', 'path'},
				gitcommit = {'git', 'buffer', 'datword', 'spell'},
				markdown  = {'snippets', 'buffer', 'path', 'git', 'emoji', 'datword', 'spell'},
				latex     = {'snippets', 'lsp', 'latex', 'buffer', 'datword', 'spell', 'path'},
				tex       = {'snippets', 'lsp', 'latex', 'buffer', 'datword', 'spell', 'path'},
				plaintex  = {'snippets', 'lsp', 'latex', 'buffer', 'datword', 'spell', 'path'},
			},
			providers = {
				snippets = {
					score_offset = 150,
				},
				lsp = {
					-- BUG: default setting `fallbacks={'buffer'}` has some bug (don't show buffer list by lsp)
					fallbacks = {},
					-- max_items = 5,
					-- score_offset = 50,
					-- ---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					transform_items = function (_, items)
						for _, item in ipairs(items) do
							-- change kind_name for tex only
							if item.client_name == 'texlab' then
								item.kind_name = CompletionItemKind_texlab[item.kind]
							end
						end
						return items
					end
				},
				buffer = {
					-- BUG: when I set max_items, some lsp's list are now shown
					max_items = 5,
				},
				path = { -- triggered by '/'
					fallbacks = {},
					opts = {
						trailing_slash = false, -- do not attach '/' automatically, it prevent to completion with triggering with '/'
						label_trailing_slash = true,
						show_hidden_files_by_default = true,
					}
				},
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 50, -- Tune by preference
					opts = { insert = true }, -- Insert emoji (default) or complete its name
				},
				spell = {
					name = 'Spell',
					score_offset = -20,
					module = 'blink-cmp-spell',
					opts = {
						-- EXAMPLE: Only enable source in `@spell` captures, and disable it
						-- in `@nospell` captures.
						preselect_current_word = false,
						keep_all_entries = true,
						enable_in_context = function()
							local curpos = vim.api.nvim_win_get_cursor(0)
							local captures = vim.treesitter.get_captures_at_pos(
								0,
								curpos[1] - 1,
								curpos[2] - 1
							)
							local in_spell_capture = false
							for _, cap in ipairs(captures) do
								if cap.capture == 'spell' then
									in_spell_capture = true
								elseif cap.capture == 'nospell' then
									return false
								end
							end
							return in_spell_capture
						end,
					},
				},
				lazydev = {
					name = "LazyDev",
					module = 'lazydev.integrations.blink',
					score_offset = 100,
				},
				git = {
					module = 'blink-cmp-git',
					name = 'Git',
					opts = {
						-- '#' to search for issues
						-- ':' to search for commits
						-- '@' to search for users
					},
				},
				datword = {
					name = 'DatWord',
					module = 'blink-cmp-dat-word',
					opts = {
						paths = {
							-- inspired from https://github.com/first20hours/google-10000-english
							vim.fn.stdpath('config') .. '/queries/dictionary/google-10000-english-usa.txt',
						},
						min_keyword_length = 2,
						spellsuggest = true,
					},
					max_items = 5,
					score_offset = -15,
				},
				latex = {
					name = 'Latex',
					module = 'blink-cmp-latex',
					opts = {
						insert_command = true, -- insert raw text instead of uni-code character
					}
				}
			},
		},
		cmdline = {
			keymap = {
				['<Tab>']   = { 'show_and_insert', 'select_next' },
				['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
				['<C-e>']   = false,
				['<C-n>']   = { 'select_next', 'fallback' }, -- for choice mode
				['<C-p>']   = { 'select_prev', 'fallback' }, -- for choice mode
				['<C-q>']   = { 'cancel' },
			}, -- use default mapping
			completion = {
				list = {
					selection = {
						preselect = false,
					}
				},
				ghost_text = {
					enabled = false,
				}
			},
		}
	},
	config = function(_, opts)
		require('blink.cmp').setup(opts)

		vim.api.nvim_set_hl(0, "BlinkCmpMenu"  , {bg = '#2C2C3E'}) -- menu bg
		vim.api.nvim_set_hl(0, "BlinkCmpSource", {bg = '#2C2C3E'}) -- component source_name's bg
		vim.api.nvim_set_hl(0, "BlinkCmpDoc"   , {bg = '#2C2C3E'}) -- documentation default bg
	end
}
-- require('blink.cmp').get_lsp_capabilities() is merged to lsp automatically when it is loaded
-- blink-cmp-dictionary : I tried to test it. but its recommendation performance is not better than blink-spell
-- 						  Using korean Dictionary, the Dictionary text file has poor data to use completion





















