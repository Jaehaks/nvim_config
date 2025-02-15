return {
{
    "catgoose/nvim-colorizer.lua",
	enabled = true,
	branch = 'fix/141-quotes_and_doublequotes',
    keys = {
		{'<leader>cc', '<Cmd>ColorizerToggle<CR>', mode = 'n', desc = 'Show color code toggle'}
	},
	opts = {
		filetypes = {}, -- disable colorizing as default
		user_commands = {'ColorizerToggle'}, -- only enable this command
		user_default_options = {
			names = false, -- disable colorizing for name
			names_custom = {
				["'r'"] = "#FF0000",
				['"r"'] = "#FF0000",
				["'g'"] = "#00FF00",
				['"g"'] = "#00FF00",
				["'b'"] = "#0000FF",
				['"b"'] = "#0000FF",
				["'c'"] = "#00FFFF",
				['"c"'] = "#00FFFF",
				["'m'"] = "#FF00FF",
				['"m"'] = "#FF00FF",
				["'y'"] = "#FFFF00",
				['"y"'] = "#FFFF00",
				["'k'"] = "#000000",
				['"k"'] = "#000000",
				["'w'"] = "#FFFFFF",
				['"w"'] = "#FFFFFF",
			}
		}

	},
},
{
	-- graphical color picker
	'eero-lehtinen/oklch-color-picker.nvim',
	keys = {
		{'<leader>cp', function() require('oklch-color-picker').pick_under_cursor() end, desc = 'Color pick under cursor' },
	},
	opts = {
		highlight = {
			enabled = false, -- disable highlighting colorcode pattern
		}
	},
},
}

-- brenoprata10/nvim-highlight-colors : labels for custom_colors are just string, not regex
-- 						it process for full-file highlighting. so it would be slow on large files.
-- 						it is what it migrate to nvim-colorizer
-- chrisbra/colorizer : it works very well. but I just want lua plugin
-- uga-rosa/ccc.nvim : cannot show colors properly Since What I install other plugins. I think it is bug..
-- 					   if modify some colorscheme, palette lose colors
-- 					   bug : if use custom_entries, other highlight are off.
-- 					   I think use it for colorcode only
-- 					   other colorpick plugins are not worked in windows






