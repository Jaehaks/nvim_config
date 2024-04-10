return {
{
},{
	'chrisbra/colorizer',
	enabled = true,
	event = 'VeryLazy',
	config = function()
		vim.g.colorizer_auto_color = 0
		vim.g.colorizer_custom_colors = {
			r = '#FF0000',
			g = '#00FF00',
			b = '#0000FF',
			c = '#00FFFF',
			m = '#FF00FF',
			y = '#FFFF00',
			k = '#000000',
			w = '#FFFFFF'
		}
		vim.keymap.set('n','<leader>cc', '<Cmd>ColorToggle<CR>', {desc = 'Show color code toggle'})

	end


},
{
	'brenoprata10/nvim-highlight-colors',
	enabled = false,
	event = 'VeryLazy',
	init = function ()
		vim.opt.termguicolors = true
	end,
	config = function ()
		require('nvim-highlight-colors').setup({
			render = 'background',
			enable_named_colors = false, -- colorize with color name, but it needs ':' ahead of the name
			enable_tailwind = false,
			custom_colors = { -- this pattern is used for gsub, so it does not same with lua regex pattern, whildcad, [set] doesn't work
				{ label= "[\'\"]red[\'\"]", color = '#FF0000' },
			}
			-- 'red'
			-- "red"
		})
	end
},
{
	-- ccc.nvim : if modify some colorscheme, palette lose colors
	-- bug : if use custom_entries, other highlight are off. 
	-- I think use it for colorcode only
	-- other colorpick plugins are not worked in windows
	'uga-rosa/ccc.nvim',
	enabled = false,
	event = 'VeryLazy',
	config = function()
		local ccc = require('ccc')
		ccc.setup({
			highlighter = {
				auto_enable = false,
				lsp = false,
			},
		})
--		vim.keymap.set('n','<leader>cc', '<Cmd>CccHighliterToggle<CR>')
		vim.keymap.set('n','<leader>cp', '<Cmd>CccPick<CR>', {desc = 'open colorcode palette'})
	end
},
}

-- brenoprata10/nvim-highlight-colors : regex pattern is not work properly, like 'r'






