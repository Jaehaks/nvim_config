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
				vim.api.nvim_set_hl(0, "Normal", { bg = "#131313", fg = "#FFFFFF" })   -- background color : black
				vim.api.nvim_set_hl(0, "SignColumn", { bg = "#131313" })               -- signcolumn : black, default is #011627 but it is more close to blue
				vim.api.nvim_set_hl(0, "VertSplit", { bg = "#131313", fg = "#131313" })               -- signcolumn : black, default is #011627 but it is more close to blue
				vim.api.nvim_set_hl(0, "Comment", { fg = "#00FFFF", bold = true })
				vim.api.nvim_set_hl(0, "LineNr", { fg = "#E0AF68"})
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E06868", bold = true})
				vim.api.nvim_set_hl(0, "Function", { fg = "#5B8FFF"})
				vim.api.nvim_set_hl(0, "Search", { fg = "#000000", bg = '#FFFF00'})    -- white_blue
				vim.api.nvim_set_hl(0, "IncSearch", { fg = "#000000", bg = '#F78C6C'}) -- orange
				vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#D6DEEB"})               -- white_blue
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#131313"})               -- black 
			end,
			group = custom_highlight,
		})
		vim.cmd([[colorscheme nightfly]])
	end
},{
	'catppuccin/nvim',
	enabled = false,
	laxy = false,
	priority = 1000,
	name = 'catppuccin',
	config = function()
		require('catppuccin').setup({
			flavour = 'mocha',
			term_colors = true,
			no_italic = true,
			no_underline = true,
			show_end_of_buffer = true,
			color_overrides = {
				mocha = {
					base = '#000000',
					mantle = '#000000',
					crust = '#000000',
				}
			}
		})
		vim.cmd.colorscheme('catppuccin')
	end
}
}
