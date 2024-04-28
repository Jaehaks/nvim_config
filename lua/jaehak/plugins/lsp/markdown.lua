return {
{
	-- markdown preview plugin
	-- BUG: (app = 'webview' only) if file open directly with double click, peekopen does not work 
	-- BUG: To execute peekopen function, you have to execute nvim-qt first and open the file lately
	-- 
	-- BUG: 240319 : open does not work in browser also 
	-- 'toppair/peek.nvim',
	-- enabled = false,
	-- -- event = {'VeryLazy'},
	-- ft = {'markdown'},
	-- -- need "deno" => choco install deno 
	-- -- build = 'deno task --quiet build:fast',
	-- config = function ()
	-- 	local peek = require('peek')
	-- 	peek.setup({
	-- 		auto_load = true, 	-- load preview when entering markdown buffer
	-- 		close_on_bdelete = true,  -- close preview on buffer delete
	-- 		app = 'browser',
	-- 	})
	--
	-- 	-- make keymap
	-- 	vim.keymap.set('n', '<leader>mp', function ()
	-- 		if peek.is_open() then
	-- 			return peek.close()
	-- 		else
	-- 			return peek.open()
	-- 		end
	-- 	end,
	-- 	{desc = 'toggle markdown preview'})
	-- end
},
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
	-- show header list
	'AntonVanAssche/md-headers.nvim',
	version = '*',
	lazy = false,
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter'
	},
	config = function ()
		local md_header = require('md-headers')
		md_header.setup({
			popup_auto_close = true

		})

		-- make keymap
		vim.keymap.set('n','<leader>mh', '<Cmd>MarkdownHeaders<CR>', {silent = true, noremap = true, desc = 'open header list'})
		vim.keymap.set('n','<leader>mc', '<Cmd>MarkdownHeadersClosest<CR>', {silent = true, noremap = true, desc = 'open header list closest'})
	end

},
{
	-- cursorline of headline highlight
	'lukas-reineke/headlines.nvim',
	enabled = true,
	ft = {'markdown'},
	dependencies = 'nvim-treesitter/nvim-treesitter',
	config = function ()

		vim.api.nvim_set_hl(0, "Headline1", { bg = "#195E52", bold = true, fg = '#FFFFFF'})                  -- for normal cursor
		vim.api.nvim_set_hl(0, "Headline2", { bg = "#3F107B", bold = true, fg = '#FFFFFF'})                  -- for normal cursor
		vim.api.nvim_set_hl(0, "Headline3", { bg = "#6F0957", bold = true, fg = '#FFFFFF'})                  -- for normal cursor
		vim.api.nvim_set_hl(0, "Headline4", { bg = "#4D3505", bold = true, fg = '#FFFFFF'})                  -- for normal cursor
		vim.api.nvim_set_hl(0, "CodeBlock", { bg = "#202020"})                  -- for normal cursor
		vim.api.nvim_set_hl(0, "Dash", { fg = "#D19A66"})                  -- for normal cursor

		require('headlines').setup({
			markdown = {
				headline_highlights = {
					'Headline1',
					'Headline2',
					'Headline3',
					'Headline4',
				},
				bullets = false,		-- don't use marker
				dash_string = false,
				quote_string = false,
				fat_headlines = false,	-- only highlight the line of headline
			}
		})
	end
}
}
