return {
{
	'brenoprata10/nvim-highlight-colors',
	enabled = false,
	init = function ()
		vim.opt.termguicolors = true
	end,
	config = function ()
		local nvim_highlight = require('nvim-highlight-colors')
		nvim_highlight.setup({
			render = 'background',
			enable_named_colors = false, -- colorize with color name, but it needs ':' ahead of the name
			enable_tailwind = false,
			custom_colors = { -- this pattern is used for gsub, so it does not same with lua regex pattern, whildcad, [set] doesn't work
				{ label= [['r']], color = '#FF0000' },
				{ label= [["r"]], color = '#FF0000' },
				{ label= [['g']], color = '#00FF00' },
				{ label= [["g"]], color = '#00FF00' },
				{ label= [['b']], color = '#0000FF' },
				{ label= [["b"]], color = '#0000FF' },
				{ label= [['c']], color = '#00FFFF' },
				{ label= [["c"]], color = '#00FFFF' },
				{ label= [['m']], color = '#FF00FF' },
				{ label= [["m"]], color = '#FF00FF' },
				{ label= [['y']], color = '#FFFF00' },
				{ label= [["y"]], color = '#FFFF00' },
				{ label= [['k']], color = '#000000' },
				{ label= [["k"]], color = '#000000' },
				{ label= [['w']], color = '#FFFFFF' },
				{ label= [["w"]], color = '#FFFFFF' },
			}
		})
		vim.keymap.set('n','<leader>cc', nvim_highlight.toggle, {desc = 'Show color code toggle'})

		nvim_highlight.turnOff() --  turn off initially
	end
},
{
	enabled = true,
    "catgoose/nvim-colorizer.lua",
	branch = 'fix/141-quotes_and_doublequotes',
    event = "BufReadPre",
	config = function ()
		local colorizer = require('colorizer')
		colorizer.setup({
			-- lazy_load = true,
			user_default_options = {
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

		})

		vim.keymap.set('n','<leader>cc', '<Cmd>ColorizerToggle<CR>', {desc = 'Show color code toggle'})
	end
},
{
	-- graphical color picker
	'eero-lehtinen/oklch-color-picker.nvim',
	config = function()
		require('oklch-color-picker').setup ({
			highlight = {
				enabled = false, -- disable highlighting colorcode pattern
			}
		})

		-- One handed keymaps recommended, you will be using the mouse
		vim.keymap.set('n', '<leader>cp', function()
			require('oklch-color-picker').pick_under_cursor()
		end, { desc = 'Color pick under cursor' })
	end,
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






