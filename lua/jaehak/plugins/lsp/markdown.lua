return {
{
	-- more works better
	'iamcco/markdown-preview.nvim',
	ft = {'markdown'},
	build = function() vim.fn["mkdp#util#install"]() end,
	config = function ()
		vim.g.mkdp_auto_start = 0 -- open preview automatically
		vim.g.mkdp_theme = 'dark'
		vim.keymap.set('n', '<leader>mp', '<Cmd>:MarkdownPreviewToggle<CR>', {desc = 'toggle markdown preview'})
	end
},
-- 'datsfilipe/md-previewer' : how to use this? 
{
	-- highlight of markdown file. but there are no delay to navigate
	'MeanderingProgrammer/markdown.nvim',
	ft = {'markdown'},
	name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		-- for heading
		vim.api.nvim_set_hl(0, 'markdownB1', {bg = '#216042'})
		vim.api.nvim_set_hl(0, 'markdownB2', {bg = '#215860'})
		vim.api.nvim_set_hl(0, 'markdownB3', {bg = '#2E2D5C'})
		vim.api.nvim_set_hl(0, 'markdownB4', {bg = '#504032'})
		vim.api.nvim_set_hl(0, 'markdownB5', {bg = '#363F4B'})
		vim.api.nvim_set_hl(0, 'markdownB6', {bg = '#473B4F'})

		-- for code / bullet
		vim.api.nvim_set_hl(0, 'RenderMarkdownCode'  , {bg = '#333333'})
		vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', {fg = '#F78C6C'})
		vim.api.nvim_set_hl(0, 'RenderMarkdownTodo'  , {fg = '#E6E6E6'})

		-- for callout
		vim.api.nvim_set_hl(0, "RenderMarkdownInfo"   , {fg = '#0DB9D7' })
		vim.api.nvim_set_hl(0, "RenderMarkdownSuccess", {fg = '#b3f6c0' })
		vim.api.nvim_set_hl(0, "RenderMarkdownHint"   , {fg = '#1abc9c' })
		vim.api.nvim_set_hl(0, "RenderMarkdownWarn"   , {fg = '#e0af68' })
		vim.api.nvim_set_hl(0, "RenderMarkdownError"  , {fg = '#db4b4b' })
		vim.api.nvim_set_hl(0, "@markup.quote"        , {fg = '#E6E6E6' })

		-- for emphasis, some features like bold / strikethrough are cannot render in terminal, but it is ok in nvim-qt
		vim.api.nvim_set_hl(0, "@markup.italic"        , {fg = '#EDFF93' , italic = true})
		vim.api.nvim_set_hl(0, "@markup.strong"        , {fg = '#E39AA6' , bold = true})
		vim.api.nvim_set_hl(0, "@markup.strikethrough" , {fg = '#999999' , strikethrough = true})


		-- setting
		require('render-markdown').setup({ -- after @56d92af
			anti_conceal = { -- it set autocmd for cursormoved, but I don't know what it does
				enabled = false,
			},
			win_options = {
				conceallevel = { 
					default  = 0,  -- for other mode rendering, if conceallevel >= 1, (```) doesn't show event insert mode
					rendered = 3,  -- for normal mode rendering
				},
				concealcursor = {  -- which mode to conceal cursorline
					default  = '',
					rendered = '', -- disable conceal at cursorline
				},
			},
			heading = {
				enabled = true,
				sign = false, -- don't show icon of heading in sign column
				icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' }, -- rendering icon of header
				backgrounds = {
					'markdownB1',
					'markdownB2',
					'markdownB3',
					'markdownB4',
					'markdownB5',
					'markdownB6',
				},
			},
			code = {
				enabled          = true,
				sign             = false,                -- don't show icon of code block in sign column
				style            = 'full',               -- symbol + Lang
				left_pad         = 0,                    -- padding to left of code block
				right_pad        = 2,                    -- for 'block' width
				width            = 'block',
				border           = 'thick',              -- render full background region of code
				highlight        = 'RenderMarkdowncode', -- highlight of code block
				highlight_inline = '',                   -- disable highlight of inline code
			},
			bullet = {
				enabled = true,
				icons = {'■', '▲', '●', '★', '▶'},
				highlight = 'RenderMarkdownBullet',
			},
			checkbox = {
				enabled = true,
				unchecked = {
					icon = ' '
				},
				checked = {
					icon = '󰄲 ',
				},
				custom = {
					todo = {raw = '[-]', rendered = '󱋭 ', highlight = 'RenderMarkdownTodo'} -- for cancel mark
				}
			},
			quote = {
				enabled = true
			},
			callout = {
				-- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
				note      = { raw = '[!NOTE]'     , rendered = '󰋽 Note'     , highlight = 'RenderMarkdownInfo' }   ,
				abstract  = { raw = '[!ABSTRACT]' , rendered = '󰨸 Abstract' , highlight = 'RenderMarkdownInfo' }   ,
				todo      = { raw = '[!TODO]'     , rendered = '󰗡 Todo'     , highlight = 'RenderMarkdownInfo' }   ,
				tip       = { raw = '[!TIP]'      , rendered = '󰌶 Tip'      , highlight = 'RenderMarkdownSuccess' },
				success   = { raw = '[!SUCCESS]'  , rendered = '󰄬 Success'  , highlight = 'RenderMarkdownSuccess' },
				example   = { raw = '[!EXAMPLE]'  , rendered = '󰉹 Example'  , highlight = 'RenderMarkdownHint' }   ,
				important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' }   ,
				warning   = { raw = '[!WARNING]'  , rendered = '󰀪 Warning'  , highlight = 'RenderMarkdownWarn' }   ,
				question  = { raw = '[!QUESTION]' , rendered = '󰘥 Question' , highlight = 'RenderMarkdownWarn' }   ,
				caution   = { raw = '[!CAUTION]'  , rendered = '󰳦 Caution'  , highlight = 'RenderMarkdownError' }  ,
				failure   = { raw = '[!FAILURE]'  , rendered = '󰅖 Failure'  , highlight = 'RenderMarkdownError' }  ,
				danger    = { raw = '[!DANGER]'   , rendered = '󱐌 Danger'   , highlight = 'RenderMarkdownError' }  ,
				bug       = { raw = '[!BUG]'      , rendered = '󰨰 Bug'      , highlight = 'RenderMarkdownError' }  ,
				quote     = { raw = '[!QUOTE]'    , rendered = '󱆨 Quote'    , highlight = 'RenderMarkdownQuote' }  ,
			},
		})
	end,
},
{
	'crispgm/telescope-heading.nvim',
	dependencies = {
		-- 'nvim-telescope/telescope.nvim',
		'Jaehaks/telescope.nvim',
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
{
	-- add bullet automatically
	-- BUG: if indent executed by TAB, the numbering does not change automatically, you should use :AutolistRecalculate
	-- it doesn't work in filetype 'NeogitCommitMessage' 
	-- 'gaoDean/autolist.nvim',
	'mcauley-penney/autolist.nvim',
	enabled = true,
	ft = {'markdown', 'text'},
	config = function ()

		local list_patterns = { -- patterns which is used for autolist
			unordered = "[-+*>]", -- use -,+,*,> for unordered list
			digit = "%d+[.)]", -- 1. or 1)
			ascii = "%a[.)]", -- a. or a)
			roman = "%u*[.)]", -- I. or I)
		}

		local autolist = require('autolist')
		autolist.setup({
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
		})

		-- Add strong mark (**) both side of visualized region
		local AddStrong = function (args)
			local start_pos = vim.fn.getpos("v")
			local end_pos   = vim.fn.getpos(".")
			local start_line, start_col = start_pos[2], start_pos[3]
			local end_line, end_col     = end_pos[2], end_pos[3]

			-- local marks = '**' -- set marks to add
			if type(args) ~= 'string' then
				vim.api.nvim_err_writeln('Error(AddStrong) : use string for args')
				return
			end
			local marks = args or '**' -- set marks to add

			-- Add asterisks at the start of the selection
			vim.api.nvim_buf_set_text(0, start_line - 1, start_col - 1, start_line - 1, start_col - 1, {marks})

			-- check end col regardless of non-ASCII char
			local lines = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)
			if start_line == end_line then -- if 'marks' is added in same line, it is included in end_col calculation
				end_col = end_col + #marks
			end
			local end_bytecol = vim.str_utfindex(lines[1], end_col)
			if end_bytecol then
				end_col = vim.str_byteindex(lines[1], end_bytecol) + 1
			else
				vim.api.nvim_err_writeln('Error(AddStrong) : end_bytecol is nil')
				return
			end

			-- Add asterisks at the end of the selection
			vim.api.nvim_buf_set_text(0, end_line - 1, end_col - 1 , end_line - 1, end_col - 1, {marks})

			-- go to normal mode
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
		end



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
				vim.keymap.set('n', '<C-m>'		, '<Cmd>AutolistCycleNext<CR>'       , opts)
				vim.keymap.set('n', '<leader>mr', '<Cmd>AutolistRecalculate<CR>'     , opts)
				vim.keymap.set('n', 'dd'        , 'dd<Cmd>AutolistRecalculate<CR>'   , opts)
				vim.keymap.set('v', 'd'         , 'd<Cmd>AutolistRecalculate<CR>'    , opts)
				vim.keymap.set('v', '<leader>mb', function () AddStrong('**') end, {buffer = true, desc = 'Enclose with **(bold)'})
				vim.keymap.set('v', '<leader>mh', function () AddStrong('==') end, {buffer = true, desc = 'Enclose with ==(highlight)'})
				vim.keymap.set('v', '<leader>ms', function () AddStrong('~~') end, {buffer = true, desc = 'Enclose with ~~(strikethrough)'})
			end
		})

	end
},

-- roodolv/markdown-toggle : autolist.nvim has more feature, but it has some bug about indent
-- 							I think after using mcauley-penny/autolist.nvim, this problem is gone
-- bullets-vim/bullets.nvim : it does not work in neovim
-- gaoDean/autolist.nvim : sometimes, it makes indent problem when I put indent in front of word at the beginning line
-- 						   when I enter TAB, indent is inserted after first character of the word. 
-- 						   It is a big reason of why I migrate to other plugin
{
	-- editing fenced code block using treesitter
	'AckslD/nvim-FeMaco.lua',
	ft = {'markdown'},
	config = function ()
		local femaco = require('femaco')
		femaco.setup({ })
		vim.keymap.set('n', '<leader>mc', require('femaco.edit').edit_code_block, {noremap = true, desc = 'Edit code block'})
	end

},
{
	'allaman/emoji.nvim',
	ft = 'markdown',
	dependencies = {
		'nvim-telescope/telescope.nvim'
	},
	config = function ()
		require('emoji').setup({
			enabled_cmp_integration = false,
		})

		local ts = require('telescope').load_extension('emoji')
		vim.keymap.set('n', '<leader>fe', ts.emoji, { desc = 'Search Emoji' })
	end
}
}
-- dburian/cmp-markdown-link : for current directory file link,  cmp-path is more useful (it allow fuzzy search)
-- HakonHarnes/img-clip.nvim : it replaced with obisidian.nvim's paste function.
