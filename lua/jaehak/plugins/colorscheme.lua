return{{
	'bluz71/vim-nightfly-colors',
	enabled = true,
	lazy = false, -- start
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
				vim.api.nvim_set_hl(0, "Normal"      , { bg = "#131313", fg = "#FFFFFF" }) -- background color : black
				vim.api.nvim_set_hl(0, "SignColumn"  , { bg = "#131313" })                 -- signcolumn : black, default is #011627 but it is more close to blue
				vim.api.nvim_set_hl(0, "VertSplit"   , { bg = "#131313", fg = "#131313" }) -- signcolumn : black, default is #011627 but it is more close to blue
				vim.api.nvim_set_hl(0, "Comment"     , { fg = "#00FFFF", bold = true })
				vim.api.nvim_set_hl(0, "LineNr"      , { fg = "#E0AF68"})
				vim.api.nvim_set_hl(0, "Cursor"      , { bg = "#00FF00"})                  -- for normal cursor (not work in nvim-qt)
				vim.api.nvim_set_hl(0, "CursorLine"  , { bg = "#0C3B60"})
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E06868", bold = true})
				vim.api.nvim_set_hl(0, "Function"    , { fg = "#5B8FFF"})
				vim.api.nvim_set_hl(0, "Search"      , { fg = "#000000", bg = '#FFFF00'})  -- white_blue
				vim.api.nvim_set_hl(0, "IncSearch"   , { fg = "#000000", bg = '#F78C6C'})  -- orange
				vim.api.nvim_set_hl(0, "FloatBorder" , { fg = "#D6DEEB"})                  -- white_blue
				vim.api.nvim_set_hl(0, "NormalFloat" , { bg = "#131313"})                  -- black
				vim.api.nvim_set_hl(0, "MatchParen"  , { fg = "#000000", bg = "#FE00FF"})  -- for match paren
				vim.api.nvim_set_hl(0, "Visual"  	 , { link = 'CursorLine'})
			end,
			group = custom_highlight,
		})
		vim.cmd([[colorscheme nightfly]])
	end
}
}
-- 'folke/tokyonight.nvim' : it is very cool, but I want more strong contrast colorschme
