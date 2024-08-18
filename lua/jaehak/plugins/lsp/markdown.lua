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

		-- for code / bullet
		vim.api.nvim_set_hl(0, 'RenderMarkdownCode', {bg = '#333333'})
		vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', {fg = '#F78C6C'})

		-- for callout
		vim.api.nvim_set_hl(0, "RenderMarkdownInfo"   , {fg = '#0DB9D7' })
		vim.api.nvim_set_hl(0, "RenderMarkdownSuccess", {fg = '#b3f6c0' })
		vim.api.nvim_set_hl(0, "RenderMarkdownHint"   , {fg = '#1abc9c' })
		vim.api.nvim_set_hl(0, "RenderMarkdownWarn"   , {fg = '#e0af68' })
		vim.api.nvim_set_hl(0, "RenderMarkdownError"  , {fg = '#db4b4b' })
		vim.api.nvim_set_hl(0, "@markup.quote"        , {fg = '#E6E6E6' })

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
				enabled = false,
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
{
	-- add bullet automatically
	-- BUG: if indent executed by TAB, the numbering does not change automatically, you should use :AutolistRecalculate
	-- it doesn't work in filetype 'NeogitCommitMessage' 
	-- 'gaoDean/autolist.nvim',
	'mcauley-penney/autolist.nvim',
	enabled = true,
	ft = {'markdown', 'text'},
	config = function ()
		local autolist = require('autolist')
		autolist.setup({

		})

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
			end
		})

	end
},
{
	'roodolv/markdown-toggle.nvim',
	enabled = false,
	config = function()
		-- settings
		local enabled_filetype = { 'markdown', 'text' }
		require('markdown-toggle').setup({
			use_default_keymaps = false,
			filetypes = enabled_filetype,

			enable_list_cycle = true,
			list_table = { '-', '+', '*', '=' },

			enable_box_cycle = true,
			box_table = { 'x', '~', '!', '>' },

			mimic_obsidian_list = true,
			mimic_obsidian_cycle = true,

			heading_table = { '#', '##', '###', '####', '#####' },

			enable_blankhead_skip = true,
			enable_inner_indent = false,
			enable_unmarked_only = true, -- toggle unmarked lines first
			enable_autolist = true,
			enable_auto_samestate = false, -- maintain checkbox state when continusing list
			enable_dot_repeat = false, -- dot repeat for toggle function
		})

		vim.api.nvim_create_autocmd('Filetype', {
			desc = 'keymap for markdown-toggle.nvim',
			pattern = enabled_filetype,
			callback = function (args)
				local opts  = {silent = true, noremap = true, buffer = args.buf}
				local toggle = require('markdown-toggle')

				-- for toggle list
				vim.keymap.set({ "n", "x" }, "<leader>mq", toggle.quote, opts)
				vim.keymap.set({ "n", "x" }, "<leader>mw", toggle.list, opts)
				vim.keymap.set({ "n", "x" }, "<leader>me", toggle.olist, opts)
				vim.keymap.set({ "n", "x" }, "<leader>mc", toggle.checkbox, opts)
				vim.keymap.set({ "n", "x" }, "<leader>mt", toggle.heading, opts)

				-- for autolist
				vim.keymap.set("n", "O", toggle.autolist_up, opts)
				vim.keymap.set("n", "o", toggle.autolist_down, opts)
				vim.keymap.set("i", "<CR>", toggle.autolist_cr, opts)
			end

		})

	end,

},
-- bullets-vim/bullets.nvim : it does not work in neovim
-- gaoDean/autolist.nvim : sometimes, it makes indent problem when I put indent in front of word at the beginning line
-- 						   when I enter TAB, indent is inserted after first character of the word. 
-- 						   It is a big reason of why I migrate to other plugin
{
	'HakonHarnes/img-clip.nvim', -- paste image link and download file from clipboard
	enabled = false,
	ft = {'markdown'},
	config = function ()
		local img = require('img-clip')
		img.setup({
			default = {
				dir_path = function ()
					return 'img_' .. vim.fn.expand('%:t:r')
				end,
				extension = 'png',
				file_name = '%Y-%m-%d',
				relative_to_current_file = true,

				insert_mode_after_paste = true,
				show_dir_path_in_prompt = false;

				copy_images = true,
				download_images = true,

				drag_and_drop = {
					enabled = false,
				},
				filetypes = {
					markdown = {
						url_encode_path = true,
						template = "![$CURSOR]($FILE_PATH)",
						download_images = true,
					}
				}
			}
		})
		vim.keymap.set('n', '<leader>mv', img.paste_image, {noremap = true, desc = 'Paste Image From Clipboard'})
	end
},
{
	-- editing fenced code block using treesitter
	'AckslD/nvim-FeMaco.lua',
	ft = {'markdown'},
	config = function ()
		local femaco = require('femaco')
		femaco.setup({ })
		vim.keymap.set('n', '<leader>mc', require('femaco.edit').edit_code_block, {noremap = true, desc = 'Edit code block'})
	end

}
}
-- dburian/cmp-markdown-link : for current directory file link,  cmp-path is more useful (it allow fuzzy search)
