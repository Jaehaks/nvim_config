local utils = require('jaehak.core.utils')
return {
{
	-- BUG: it doesn't work with `app = 'webview`, you must use browser
	-- markdown live preview. it needs deno
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
	keys = {
		{'<leader>mp', function ()
			if require('peek').is_open() then
				require('peek').close()
			else
				require('peek').open()
			end
		end, desc = '[markdown] open browser preview'},
	},
	opts = {
		auto_load = false, -- open live preview whenever you open .md file
		app = 'brave',
		filetype = {'markdown'},
	},
},
-- 'datsfilipe/md-previewer' : how to use this?
-- 'iamcco/markdown-preview.nvim' : it doesn't work anymore
-- 'brianhuster/live-preview.nvim' : it invokes some error while preview in web browser
{
	"OXY2DEV/markview.nvim",
	enabled = true,
	event = {'InsertEnter'},
	ft = {'markdown'},
	opts = function()
		-- set highlights
		vim.api.nvim_set_hl(0, "@markup.italic",             {fg = '#3DC5DA', italic = true})
		vim.api.nvim_set_hl(0, "@markup.strong",             {fg = '#E39AA6', bold = true})
		vim.api.nvim_set_hl(0, "@markup.strikethrough",      {fg = '#999999', strikethrough = true})
		vim.api.nvim_set_hl(0, "@markup.underline",          {underline = true})
		vim.api.nvim_set_hl(0, "MarkviewHighlights",         {fg = '#f2ed5e', bg = '#1a190c'} ) -- "== text =="
		vim.api.nvim_set_hl(0, "MarkviewListItemMinus",      {fg = '#F68C6B'} )
		vim.api.nvim_set_hl(0, "MarkviewListItemPlus",       {fg = '#b1c61c'} )
		vim.api.nvim_set_hl(0, "MarkviewListItemStar",       {fg = '#00d1dd'} )
		vim.api.nvim_set_hl(0, 'MarkviewCheckboxCancelled',  {fg = '#999999'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteDefault',  {link = 'Normal'}) -- default block quote color
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteAnswer',   {default = true, fg = '#FE86D8'}) -- default block quote color
		vim.api.nvim_set_hl(0, 'MarkviewPalette1Sign',       {link = 'markdownH1'})
		vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', {link = 'markdownH1'}) -- heading highlights in insert mode

		return{
			preview = {
				hybrid_modes         = {'n'}, -- disable conceal specific region under cursor
				linewise_hybrid_mode = true,  -- apply hybrid mode with line-wise not block-wise
			},
			html = {
				container_elements = {
					["^u$"] = { -- underline
						on_node = { hl_group = "@markup.underline" },
					},
				}
			},
			markdown = {
				headings = {
					heading_1 ={
						style = "label", sign = "", sign_hl = "", align = "center",
						padding_left = "╾────────────────╴ ", padding_right = " ╶────────────────╼",
						icon = "󰼏 ", hl = "MarkviewHeading1Sign",
					},
					heading_2 = { style = "icon", sign = "", sign_hl = "", icon = "󰎨 ", hl = "MarkviewHeading2",},
					heading_3 = { style = "icon", sign = "", sign_hl = "", icon = "󰼑 ", hl = "MarkviewHeading3",},
					heading_4 = { style = "icon", sign = "", sign_hl = "", icon = "󰎲 ", hl = "MarkviewHeading4",},
					heading_5 = { style = "icon", sign = "", sign_hl = "", icon = "󰼓 ", hl = "MarkviewHeading5",},
					heading_6 = { style = "icon", sign = "", sign_hl = "", icon = "󰎴 ", hl = "MarkviewHeading6",},
				},
				code_blocks = {
					style = 'block', -- only highlight behind code region, not all
					label_direction = 'left',
					pad_amount = 0,  -- turn off left indentation
					sign = false,    -- turn off icon in signcolumn
				},
				horizontal_rules = { -- horizontal line pattern '---'
					parts = {
						{
							type = "repeating",
							repeat_amount = function ()
								return vim.o.columns; -- repeat to whole column
							end,
							text = "━",
							hl = "MarkviewGradient9"
						}
					}
				},
				list_items = {
					marker_minus       = { add_padding = false, text = '' }, -- When using '-'
					marker_plus        = { add_padding = false, },            -- When using '+'
					marker_star        = { add_padding = false, },            -- When using '*'
					marker_dot         = { add_padding = false, },            -- When using '.'
					marker_parenthesis = { add_padding = false, },            -- When using '1), 2)'
				},
				block_quotes = {
					["ANSWER"] = {
						preview = " Answer",
						hl = "MarkviewBlockQuoteAnswer",
						title = true,
						icon = "",
						border = "▋"
					},
				}
			},
			markdown_inline = {
				highlights = { -- pattern "==word=="
					padding_left = "",
					padding_right = "",
					default = { hl = "MarkviewHighlights" }
				},
				checkboxes = {
					checked   = { text = "", hl = "MarkviewCheckboxChecked", scope_hl = false },
					unchecked = { text = "", hl = "MarkviewCheckboxUnchecked", scope_hl = false},
					["-"]     = { text = "󱋭", hl = "MarkviewCheckboxCancelled", scope_hl =  "MarkviewCheckboxCancelled"},
				},
				emoji_shorthands = { enable = false, },
				images = {
					["%.png$"] = { icon = "󰥶 "},
					["%.jpg$"] = { icon = "󰥶 "},
					["%.gif$"] = { icon = " "},
				},
				internal_links = {}, -- pattern "[[#title]]", internal link in current file
				uri_autolinks  = {}, -- pattern "<https://example.com>", direct link without link name
			},
			latex = { enable = false, }, -- $ $ for inline rendering / $$ $$ for block rendering
			typst = { enable = false, },
			yaml  = { enable = false, }
		}
	end,
	config = function (_, opts)
		vim.g.markview_blink_loaded = true -- disable callout completion of markview for blink.cmp
		require('markview').setup(opts)
	end
},
{
	'crispgm/telescope-heading.nvim',
	enabled = false,
	dependencies = {
		'nvim-telescope/telescope.nvim',
	},
	ft = {'markdown'},
	config = function ()
		require('telescope').load_extension('heading')
		vim.keymap.set('n', '<leader>mh', '<Cmd>Telescope heading<CR>' , {desc = 'show header of markdown'})
	end
},
-- without any lsp, default filetype detector support syntax highlighting
-- treesitter-markdown make using conceal possible. but it is not perfect
	-- without headlines.nvim, It confused to discern code block and link => I turned of conceal of markdown
-- mkdnflow.nvim : main function is link and table editing
		-- 1) pros: it can access and make link with <CR>, it will be convenient reading README.md
		-- 2) pros : increase / decrease heading
		-- 3) cons: it support auto indent numbering / but :MkdnUpdateNumbering cannot update like autolist.nvim
		--			=> use autolist.nvim and disable function about list item of mkdnflow
		-- 4) cons : conceal is not perfect. but treesitter cannot conceal without link
		-- mkdnflow is very functional, it seems to be well-used for creating tables and links.
		-- but for me, these are too much, so I disable lots of functions
-- tadmccorkle/markdown.nvim : I didn't use toc and shortcut usually. toc is feature of note taking plugins too
--'AntonVanAssche/md-headers.nvim' : make toc list to navigate. it is replaced by markdown.nvim
		-- it needs long load time
--'ixru/nvim-markdown' : It dose not have recalculating number list
--'OXY2DEV/markview.nvim' : default highlight is poor, if I set any configuration, it doesn't work all
--						  : it seems more faster than render-markdown.nvim. and it highlights correctly
--						  although screen is moved and the first marks are not shown.
--					 pros: (over render-markdown)
--					     1. supports latex / html marker
--					     2. supports more customizable heading style
--					     3. rendering speed is fast because it render only current view, not
--					        file
--					     4. it render correclty even though marker doesn't be shown in the
--					        screen. it remains highlight when I move cursor to right
--					 cons:
--					     1. anti-conceal speed of linewise hybrid mode is slow
{
	-- add bullet automatically
	-- BUG: if indent executed by TAB, the numbering does not change automatically, you should use :AutolistRecalculate
	-- it doesn't work in filetype 'NeogitCommitMessage'
	-- 'gaoDean/autolist.nvim',
	'mcauley-penney/autolist.nvim',
	enabled = true,
	ft = {'markdown', 'text'},
	opts = function ()
		local list_patterns = { -- patterns which is used for autolist
			unordered = "[-+*>]", -- use -,+,*,> for unordered list
			digit = "%d+[.)]", -- 1. or 1)
			ascii = "%a[.)]", -- a. or a)
			roman = "%u*[.)]", -- I. or I)
		}

		-- keymap set for markdown
		local User_markdown = vim.api.nvim_create_augroup('User_markdown', {clear = true})
		vim.api.nvim_create_autocmd('FileType',{
			group = User_markdown,
			pattern = {'markdown', 'text'},
			callback = function ()
				local opts = {noremap = true, buffer = 0}
				vim.keymap.set('i', '<TAB>'     , '<Cmd>AutolistTab<CR>'             , opts)
				vim.keymap.set('i', '<S-TAB>'   , '<Cmd>AutolistShiftTab<CR>'        , opts)
				vim.keymap.set('i', '<CR>'      , '<CR><Cmd>AutolistNewBullet<CR>'   , opts)
				vim.keymap.set('n', 'o'         , 'o<Cmd>AutolistNewBullet<CR>'      , opts)
				vim.keymap.set('n', 'O'         , 'O<Cmd>AutolistNewBulletBefore<CR>', opts)
				-- vim.keymap.set('n', '<C-m>'		, '<Cmd>AutolistCycleNext<CR>'       , opts)
				vim.keymap.set('n', '<leader>mr', '<Cmd>AutolistRecalculate<CR>'     , opts)
				-- vim.keymap.set('n', 'dd'        , 'dd<Cmd>AutolistRecalculate<CR>'   , opts)
				-- vim.keymap.set('v', 'd'         , 'd<Cmd>AutolistRecalculate<CR>'    , opts)
				vim.keymap.set('v', '<leader>mb', function () utils.AddStrong('**') end, {buffer = true, desc = 'Enclose with **(bold)'})
				vim.keymap.set('v', '<leader>mh', function () utils.AddStrong('==') end, {buffer = true, desc = 'Enclose with ==(highlight)'})
				vim.keymap.set('v', '<leader>ms', function () utils.AddStrong('~~') end, {buffer = true, desc = 'Enclose with ~~(strikethrough)'})
				vim.keymap.set('v', '<leader>mu', function () utils.AddStrong('<u>') end, {buffer = true, desc = 'Enclose with <u>(underline)'})
				vim.keymap.set('v', '<leader>mm', function () utils.AddStrong('<mark>') end, {buffer = true, desc = 'Enclose with <mark>(mark highlight)'})
				vim.keymap.set('v', '<leader>m=', function () utils.AddStrong('<sup>') end, {buffer = true, desc = 'Enclose with <sup>(sup highlight)'})
				vim.keymap.set('v', '<leader>m-', function () utils.AddStrong('<sub>') end, {buffer = true, desc = 'Enclose with <sub>(sub highlight)'})

				-- Don't remap to <C-m>, it synchronize with <CR>
			end
		})

		return {
			lists = {
				markdown = {
					list_patterns.unordered,
					list_patterns.digit,
					list_patterns.ascii,
					list_patterns.roman,
				},
				text = {
					list_patterns.unordered,
					list_patterns.digit,
					list_patterns.ascii,
					list_patterns.roman,
				}
			}
		}

	end,
},

-- roodolv/markdown-toggle : autolist.nvim has more feature, but it has some bug about indent
-- 							I think after using mcauley-penny/autolist.nvim, this problem is gone
-- bullets-vim/bullets.nvim : it does not work in neovim
-- gaoDean/autolist.nvim : sometimes, it makes indent problem when I put indent in front of word at the beginning line
-- 						   when I enter TAB, indent is inserted after first character of the word.
-- 						   It is a big reason of why I migrate to other plugin
{
	-- editing fenced code block using treesitter
	'Jaehaks/nvim-FeMaco.lua',
	branch = 'development',
	keys = {
		{'<leader>mc', function () require('femaco.edit').edit_code_block() end, noremap = true, desc = 'Edit code block'},
	},
	opts = {

	},
},
{
	'allaman/emoji.nvim',
	enabled = false,
	ft = 'markdown',
	opts = {
		enable_cmp_integration = true, -- cmp integration requires 14MB RAM
	}
},
{
	'SCJangra/table-nvim',
	keys = {
		{'<leader>mt', function() require('table-nvim.edit').insert_table() end, 'n'},
		{'<leader>mT', function() require('table-nvim.edit').insert_table_alt() end, 'n'},
	},
	opts = {
		padd_column_separators = true,          -- Insert a space around column separators.
		mappings = {                            -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
			next                = '<A-S-l>',    -- Go to next cell.
			prev                = '<A-S-h>',    -- Go to previous cell.
			insert_row_up       = '<A-j>',      -- Insert a row above the current row.
			insert_row_down     = '<A-k>',      -- Insert a row below the current row.
			move_row_up         = '<A-C-j>',    -- Move the current row up.
			move_row_down       = '<A-C-k>',    -- Move the current row down.
			insert_column_left  = '<A-h>',      -- Insert a column to the left of current column.
			insert_column_right = '<A-l>',      -- Insert a column to the right of current column.
			move_column_left    = '<A-C-h>',    -- Move the current column to the left.
			move_column_right   = '<A-C-l>',    -- Move the current column to the right.
			insert_table        = '<leader>mt', -- Insert a new table.
			insert_table_alt    = '<leader>mT', -- Insert a new table that is not surrounded by pipes.
			delete_column       = '<A-C-d>',    -- Delete the column under cursor.
		}
	},
},
{
	'Jaehaks/md-utility.nvim',
	ft = {'markdown'},
	opts = {

	}
}
}
-- dburian/cmp-markdown-link : for current directory file link,  cmp-path is more useful (it allow fuzzy search)
-- HakonHarnes/img-clip.nvim : it replaced with obisidian.nvim's paste function.
-- 'allaman/emoji.nvim' : it is replaced with
