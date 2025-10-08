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
	ft = {'markdown'},
	init = function ()
		-- disable callout completion of markview for blink.cmp
		vim.g.markview_blink_loaded = true
		-- after b895174 commit, recommends `lazy = false` to load this plugin. because it improve startup time under 5ms.
		-- If you use lazy loading, use `markview.highlights.setup()` to load this.
		-- and if you want to show hidden title of fenced_code_block, use `require('markview').actions.set_query(args.buf)`
		-- After de79a76 commit, `vim.g.markview_lazy_loaded` is supports to lazy load to do all these things
		vim.g.markview_lazy_loaded = true
	end,
	opts = {
		experimental = {
			check_rtp_message = false
		},
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
					icon = "[%d] ", hl = "markdownH1",
				},
				heading_2 = { style = "icon", sign = "", sign_hl = "", icon = "[%d.%d] ", hl = "MarkviewHeading2",},
				heading_3 = { style = "icon", sign = "", sign_hl = "", icon = "[%d.%d.%d] ", hl = "MarkviewHeading3",},
				heading_4 = { style = "icon", sign = "", sign_hl = "", icon = "[%d.%d.%d.%d] ", hl = "MarkviewHeading4",},
				heading_5 = { style = "icon", sign = "", sign_hl = "", icon = "[%d.%d.%d.%d.%d] ", hl = "MarkviewHeading5",},
				heading_6 = { style = "icon", sign = "", sign_hl = "", icon = "[%d.%d.%d.%d.%d.%d] ", hl = "MarkviewHeading6",},
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
				["ANSWER"]    = { hl = "MarkviewBlockQuoteAnswer",    preview = " Answer",    title = true, icon = "", border = "▋" },
				["ABSTRACT"]  = { hl = "MarkviewBlockQuoteAbstract",  preview = "󱉫 Abstract",  title = true, icon = "󱉫", },
				["SUMMARY"]   = { hl = "MarkviewBlockQuoteSummary",   preview = "󱉫 Summary",   title = true, icon = "󱉫", },
				["TLDR"]      = { hl = "MarkviewBlockQuoteTldr",      preview = "󱉫 Tldr",      title = true, icon = "󱉫", },
				["TODO"]      = { hl = "MarkviewBlockQuoteTodo",      preview = " Todo",      title = true, icon = "", },
				["INFO"]      = { hl = "MarkviewBlockQuoteInfo",      preview = " Info",      title = true, icon = "", },
				["NOTE"]      = { hl = "MarkviewBlockQuoteNote",      preview = "󰋽 Note",      title = true, icon = "󰋽", },
				["SUCCESS"]   = { hl = "MarkviewBlockQuoteNote",      preview = "󰗠 Success",   title = true, icon = "󰗠", },
				["CHECK"]     = { hl = "MarkviewCheckboxChecked",     preview = "󰗠 Check",     title = true, icon = "󰗠", },
				["DONE"]      = { hl = "MarkviewCheckboxChecked",     preview = "󰗠 Done",      title = true, icon = "󰗠", },
				["HINT"]      = { hl = "MarkviewBlockQuoteHint",      preview = " Hint",      title = true, icon = "", },
				["TIP"]       = { hl = "MarkviewBlockQuoteTip",       preview = " Tip",       title = true, icon = "", },
				["QUESTION"]  = { hl = "MarkviewBlockQuoteQuestion",  preview = "󰋗 Question",  title = true, icon = "󰋗", },
				["HELP"]      = { hl = "MarkviewBlockQuoteHelp",      preview = "󰋗 Help",      title = true, icon = "󰋗", },
				["FAQ"]       = { hl = "MarkviewBlockQuoteFAQ",       preview = "󰋗 Faq",       title = true, icon = "󰋗", },
				["ATTENTION"] = { hl = "MarkviewBlockQuoteAttention", preview = " Attention", title = true, icon = "", },
				["WARNING"]   = { hl = "MarkviewBlockQuoteWarning",   preview = " Warning",   title = true, icon = "", },
				["FAILURE"]   = { hl = "MarkviewBlockQuoteFail",      preview = "󰅙 Failure",   title = true, icon = "󰅙", },
				["FAIL"]      = { hl = "MarkviewBlockQuoteFail",      preview = "󰅙 Fail",      title = true, icon = "󰅙", },
				["MISSING"]   = { hl = "MarkviewBlockQuoteMissing",   preview = "󰅙 Missing",   title = true, icon = "󰅙", },
				["DANGER"]    = { hl = "MarkviewBlockQuoteDanger",    preview = " Danger",    title = true, icon = "", },
				["ERROR"]     = { hl = "MarkviewBlockQuoteError",     preview = " Error",     title = true, icon = "", },
				["BUG"]       = { hl = "MarkviewBlockQuoteBug",       preview = " Bug",       title = true, icon = "", },
				["CAUTION"]   = { hl = "MarkviewBlockQuoteCaution",   preview = "󰳦 Caution",   title = true, icon = "󰳦", },
				["EXAMPLE"]   = { hl = "MarkviewBlockQuoteExample",   preview = "󱖫 Example",   title = true, icon = "󱖫", },
				["QUOTE"]     = { hl = "MarkviewBlockQuoteQuote",     preview = " Quote",     title = true, icon = "", },
				["CITE"]      = { hl = "MarkviewBlockQuoteCite",      preview = " Cite",      title = true, icon = "", },
				["IMPORTANT"] = { hl = "MarkviewBlockQuoteImportant", preview = " Important", title = true, icon = "", },
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
		latex = { enable = false, }, -- $ $ for inline rendering / $$ $$ for block rendering in markdown file (not .tex)
		typst = { enable = false, },
		yaml  = { enable = false, }
	},
	config = function (_, opts)
		-- set highlights
		-- It needs to call in `config` field to overwrite. not `init` field.
		vim.api.nvim_set_hl(0, "@markup.italic",             {fg = '#3DC5DA', italic = true})
		vim.api.nvim_set_hl(0, "@markup.strong",             {fg = '#E39AA6', bold = true})
		vim.api.nvim_set_hl(0, "@markup.strikethrough",      {fg = '#999999', strikethrough = true})
		vim.api.nvim_set_hl(0, "@markup.underline",          {underline = true})
		vim.api.nvim_set_hl(0, "MarkviewHighlights",         {fg = '#f2ed5e', bg = '#1a190c'} ) -- "== text =="
		vim.api.nvim_set_hl(0, "MarkviewListItemMinus",      {fg = '#F68C6B'} )
		vim.api.nvim_set_hl(0, "MarkviewListItemPlus",       {fg = '#b1c61c'} )
		vim.api.nvim_set_hl(0, "MarkviewListItemStar",       {fg = '#00d1dd'} )
		vim.api.nvim_set_hl(0, 'MarkviewCheckboxCancelled',  {fg = '#999999'})
		vim.api.nvim_set_hl(0, 'MarkviewPalette1Sign',       {link = 'markdownH1'})
		vim.api.nvim_set_hl(0, 'MarkviewHeading2',       	 {fg = '#FFCC00', bg = '#332a00'})
		vim.api.nvim_set_hl(0, 'MarkviewHeading3',       	 {fg = '#FF69B4', bg = '#1f0a15'})
		vim.api.nvim_set_hl(0, 'MarkviewHeading4',       	 {fg = '#00BFFF', bg = '#00151e'})
		vim.api.nvim_set_hl(0, 'MarkviewHeading5',       	 {fg = '#9932CC', bg = '#0e0018'})
		vim.api.nvim_set_hl(0, 'MarkviewHeading6',       	 {fg = '#b386ff', bg = '#0a001a'})
		vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', {link = 'markdownH1'}) -- heading highlights in insert mode
		vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', {link = 'MarkviewHeading2'})
		vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', {link = 'MarkviewHeading3'})
		vim.api.nvim_set_hl(0, '@markup.heading.4.markdown', {link = 'MarkviewHeading4'})
		vim.api.nvim_set_hl(0, '@markup.heading.5.markdown', {link = 'MarkviewHeading5'})
		vim.api.nvim_set_hl(0, '@markup.heading.6.markdown', {link = 'MarkviewHeading6'})

		-- colorscheme of callouts.
		-- markview's color are changed often. consistence is needed.
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteDefault',   {link = 'Normal'}) -- default block quote color

		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteAnswer',    {fg = '#FE86D8'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteAbstract',  {fg = '#ff49b4'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteSummary',   {fg = '#FFc0cb'})

		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteNote',      {fg = '#00ced1'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteInfo',      {fg = '#56B6C2'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteTodo',      {fg = '#61afef'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteTldr',      {fg = '#4a8588'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteHint',      {fg = '#1e90ff'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteTip',       {fg = '#7fffd4'})

		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteAttention', {fg = '#50fa7b'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteQuestion',  {fg = '#82c91e'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteHelp',      {fg = '#3cb371'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteFAQ',       {fg = '#abdadc'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteCite',      {fg = '#bbe986'})

		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteCheck',     {fg = '#ffd700'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteWarning',   {fg = '#ffff00'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteCaution',   {fg = '#f9f5a6'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteImportant', {fg = '#ff9900'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteExample',   {fg = '#cc5500'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteQuote',     {fg = '#daa520'})

		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteFail',      {fg = '#A52A2A'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteMissing',   {fg = '#FF6984'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteDanger',    {fg = '#FF0000'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteError',     {fg = '#CC3333'})
		vim.api.nvim_set_hl(0, 'MarkviewBlockQuoteBug',       {fg = '#800000'})


		require('markview').setup(opts)
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
-- roodolv/markdown-toggle : autolist.nvim has more feature, but it has some bug about indent
-- 							I think after using mcauley-penny/autolist.nvim, this problem is gone
-- bullets-vim/bullets.nvim : it does not work in neovim
-- gaoDean/autolist.nvim : sometimes, it makes indent problem when I put indent in front of word at the beginning line
-- 						   when I enter TAB, indent is inserted after first character of the word.
-- 						   It is a big reason of why I migrate to other plugin
-- 						   It is replaced by Jaehaks/md-utility.nvim
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
	ft = {'markdown', 'text'},
	opts = {
		file_picker = {
			ignore = {
				'.git/',
				'node_modules/',
				'.obsidian/',
				'.marksman.toml',
			}
		},
		paste = {
			image_path = function (ctx)
				return ctx.cur_dir .. vim.fn.expand('%:t:r')
			end
		}
	},
	config = function (_, opts)
		local md = require('md-utility')
		md.setup(opts)

		local User_markdown = vim.api.nvim_create_augroup('User_markdown', {clear = true})
		vim.api.nvim_create_autocmd('FileType',{
			group = User_markdown,
			pattern = {'markdown', 'text'},
			callback = function ()

				vim.keymap.set({'n'}, 'gf', md.follow_link, {buffer = true, noremap = true, desc = 'follow link(image,url,file)'})
				vim.keymap.set('n', '<leader>ml', md.link_picker, {buffer = true, desc = 'show linklist'})
				vim.keymap.set({'n', 'i'}, '<M-e>', function() md.file_picker('wiki') end, {buffer = true, desc = 'show linklist'})
				vim.keymap.set({'n', 'v'}, 'P', function() md.clipboard_paste('markdown') end, {buffer = true, noremap = true, desc = 'Clipbaord paste'})

				-- autolist <CR>
				vim.keymap.set({'i'}, '<CR>', 	function()
					md.autolist_cr(true)
				end,  {buffer = true, noremap = true, desc = '<CR> with autolist mark'})

				-- without autolist <M-CR>
				vim.keymap.set({'i'}, '<M-CR>', function()
					md.autolist_cr(false)
				end, {buffer = true, noremap = true, desc = '<CR> without autolist mark but add indent'})

				-- autolist o
				vim.keymap.set({'n'}, 'o', 	function()
					md.autolist_o(true)
				end,  {buffer = true, noremap = true, desc = '"o" with autolist mark'})

				-- autolist tab
				vim.keymap.set({'i'}, '<TAB>', 	function()
					md.autolist_tab(false)
				end,  {buffer = true, noremap = true, desc = '<TAB> with autolist mark'})

				-- reverse autolist tab
				vim.keymap.set({'i'}, '<S-TAB>', function()
					md.autolist_tab(true)
				end,  {buffer = true, noremap = true, desc = '<S-TAB> with autolist mark'})

				-- recalculate list markers
				vim.keymap.set({'n'}, '<leader>mr', function()
					md.autolist_recalculate()
				end,  {buffer = true, noremap = true, desc = 'recalculate list numbering'})

				-- recalculate list markers
				vim.keymap.set({'n', 'i'}, '<C-c>', function()
					md.autolist_checkbox()
				end,  {buffer = true, noremap = true, desc = 'surround checkbox'})

				vim.keymap.set('v', '<leader>mb', function () md.addstrong('**') end, {buffer = true, desc = 'Enclose with **(bold)'})
				vim.keymap.set('v', '<leader>mh', function () md.addstrong('==') end, {buffer = true, desc = 'Enclose with ==(highlight)'})
				vim.keymap.set('v', '<leader>ms', function () md.addstrong('~~') end, {buffer = true, desc = 'Enclose with ~~(strikethrough)'})
				vim.keymap.set('v', '<leader>mu', function () md.addstrong('<u>') end, {buffer = true, desc = 'Enclose with <u>(underline)'})
				vim.keymap.set('v', '<leader>mm', function () md.addstrong('<mark>') end, {buffer = true, desc = 'Enclose with <mark>(mark highlight)'})
				vim.keymap.set('v', '<leader>m=', function () md.addstrong('<sup>') end, {buffer = true, desc = 'Enclose with <sup>(sup highlight)'})
				vim.keymap.set('v', '<leader>m-', function () md.addstrong('<sub>') end, {buffer = true, desc = 'Enclose with <sub>(sub highlight)'})

				-- Don't remap to <C-m>, it synchronize with <CR>
			end
		})


	end
}
}
-- dburian/cmp-markdown-link : for current directory file link,  cmp-path is more useful (it allow fuzzy search)
-- HakonHarnes/img-clip.nvim : it replaced with obisidian.nvim's paste function.
-- 'allaman/emoji.nvim' : it is replaced with
