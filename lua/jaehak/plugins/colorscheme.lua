return{{
	'folke/tokyonight.nvim',
	enabled = false,
	lazy=false,
	priority=1000,	-- make sure to load first
	opts={},
	config = function()
		-- colorscheme default setting
		require('tokyonight').setup()

		-- colorscheme addtional settings
		require('tokyonight').setup({
			transparent = false,
			style = 'night',
			styles = {
				comments = {fg = '#00FFFF', bold = true, italic = false},	-- if italic on, font is clipped
			},
			on_highlights = function(hl, c)
				hl.CursorLineNr = {
					fg = '#E06868'		-- cursorline number color
				}
				hl.LineNr = {
					fg = c.yellow,		-- change line number color : yellow
				}
			end
		})
		vim.cmd[[colorscheme tokyonight]]	-- it must be called after configuration
	end
},{
	'bluz71/vim-nightfly-colors',
	enabled = true,
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.nightflyCursorColor = false
		vim.g.nighflyItalics = false
		vim.g.nightflyNormalFloat = true
		vim.g.nightflyVirtualTextColor = true
		-- Lua initialization file
		local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "nightfly",
			callback = function()
				-- unused variable color = comment in nightfly colorscheme 
				vim.api.nvim_set_hl(0, "Comment", { fg = "#00FFFF", bold = true })
				vim.api.nvim_set_hl(0, "LineNr", { fg = "#E0AF68"})
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E06868", bold = true})
				vim.api.nvim_set_hl(0, "Function", { fg = "#C587FF"})
				vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#D6DEEB"})	-- white_blue
				vim.api.nvim_set_hl(0, "Search", { fg = "#000000", bg = '#FFFF00'})	-- white_blue
			end,
			group = custom_highlight,
		})
		vim.cmd([[colorscheme nightfly]])
	end
}
}
