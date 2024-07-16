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
{
	-- highlight of markdown file. but there are no delay to navigate
	'MeanderingProgrammer/markdown.nvim',
	ft = {'markdown'},
	name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		vim.api.nvim_set_hl(0, 'markdownB1', {bg = '#216042'})
		vim.api.nvim_set_hl(0, 'markdownB2', {bg = '#215860'})
		vim.api.nvim_set_hl(0, 'markdownB3', {bg = '#2E2D5C'})
		vim.api.nvim_set_hl(0, 'markdownB4', {bg = '#504032'})
		require('render-markdown').setup({
			highlights = {
				heading = {
					backgrounds = { 
						'markdownB1',
						'markdownB2',
						'markdownB3',
						'markdownB4',
					},
				}
			}
		})
	end,
},
{
	-- surround emphasis / make links / TOC
	'tadmccorkle/markdown.nvim',
	ft = {'markdown'},
	config = function ()
		require('markdown').setup({
			mappings = { -- applied to markdown file only
				inline_surround_toggle      = "gs",
				inline_surround_toggle_line = "gS",
				inline_surround_delete      = "ds",
				inline_surround_change      = "cs", -- `aaa` -> csci -> *aaa* 
				link_add                    = "gm",
				link_follow                 = "gM",
				go_curr_heading             = "]c",
				go_parent_heading           = "]p",
				go_next_heading             = "]]",
				go_prev_heading             = "[[",
			},
			inline_surround = {
				emphasis      = { key = "i", txt = "*", },-- italic
				strong        = { key = "b", txt = "**", },-- bold
				strikethrough = { key = "s", txt = "~~", },-- cancel line
				code          = { key = "c", txt = "`", },-- code line
			},
			link = {
				paste = {
					enable = true, -- make link when URLs are pasted
				},
			},
			toc = {
				omit_heading = "toc omit heading",
				omit_section = "toc omit section",
				markers = { "-" },
			},
			hooks = {
				follow_link = nil,
			},
			on_attach = function (bufnr)
				vim.keymap.set('n', '<leader>mh', '<Cmd>MDTocAll<CR>', {noremap = true, buffer = bufnr, desc = 'show TOC list'})
				vim.keymap.set('n', '<leader>mH', '<Cmd>MDInsertToc<CR>', {noremap = true, buffer = bufnr, desc = 'Insert TOC list'})
			end,
		})
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
--'AntonVanAssche/md-headers.nvim' : make toc list to navigate. it is replaced by markdown.nvim
		-- it needs long load time
--'ixru/nvim-markdown' : It dose not have recalculating number list
{
	-- add bullet automatically
	-- BUG: if indent executed by TAB, the numbering does not change automatically, you should use :AutolistRecalculate
	-- it doesn't work in filetype 'NeogitCommitMessage' 
	'gaoDean/autolist.nvim',
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
				vim.keymap.set('n', '<leader>mn', '<Cmd>AutolistCycleNext<CR>'       , opts)
				vim.keymap.set('n', '<leader>mr', '<Cmd>AutolistRecalculate<CR>'     , opts)
				vim.keymap.set('n', 'dd'        , 'dd<Cmd>AutolistRecalculate<CR>'   , opts)
				vim.keymap.set('v', 'd'         , 'd<Cmd>AutolistRecalculate<CR>'    , opts)
			end
		})

	end
},
-- bullets-vim/bullets.nvim : it does not work in neovim
{
	'HakonHarnes/img-clip.nvim', -- paste image link and download file from clipboard
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
}
}
-- dburian/cmp-markdown-link : for current directory file link,  cmp-path is more useful (it allow fuzzy search)
