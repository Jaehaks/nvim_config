return {
{
	-- buffer manager to edit/move buffer quickly
	-- cons : bmui.save_menu_to_file() make a file in current directory. not nvim-data
	-- 'j-morano/buffer_manager.nvim',
	-- branch = 'main',
	'Jaehaks/buffer_manager.nvim',
	enabled = false,
	branch = 'development',
	config = function ()
		local bm = require('buffer_manager')
		local bmui = require('buffer_manager.ui')
		bm.setup({
			select_menu_item_commands = {
				vsplit = {
					key = '<C-v>',
					command = 'vsplit'
				},
				hsplit = {
					key = '<C-x>',
					command = 'split'
				},
				edit = {
					key = '<CR>',
					command = 'edit'
				},
				-- BUG: mapping key doesn't work properly
			},
			-- BUG: short_file_names doesn't work properly
			-- I think it is caused by windows path delimiter '\\', it will be solved if PR(#35) is applied
			short_file_names = true, -- show shorten filename
			short_term_names = true,
			loop_nav = true,
		})

		vim.api.nvim_set_hl(0, 'BufferManagerModified', {fg = '#FF00FF'}) -- set highlight modified and not saved buffers in manager
		-- vim.keymap.set('n', '<M-m>', bmui.nav_next, {noremap = true, desc = 'go to next buffer'})
		-- vim.keymap.set('n', '<M-n>', bmui.nav_prev, {noremap = true, desc = 'go to prev buffer'})
		-- vim.keymap.set('n', '<leader>fb', bmui.toggle_quick_menu, {noremap = true, desc = 'open buffer window'})
	end
},
{
	"leath-dub/snipe.nvim",
	keys = {
		{"<leader>fb", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"}
	},
	opts = {
		ui = {
			max_height = -1, -- -1 means dynamic height
			---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
			position = "center",
			open_win_override = {
				-- title = "My Window Title",
				border = "single", -- use "rounded" for rounded border
			},
			preselect_current = false,
			text_align = "file-first",
			persist_tags = true,
		},
		hints = {
			-- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
			---@type string
			dictionary = "sadflewcmpghio",
			-- Character used to disambiguate tags when 'persist_tags' option is set
			prefix_key = ".",
		},
		navigate = {
			leader = ",",

			leader_map = {
				["d"] = function (m, i) require("snipe").close_buf(m, i) end,
				["v"] = function (m, i) require("snipe").open_vsplit(m, i) end,
				["h"] = function (m, i) require("snipe").open_split(m, i) end,
			},

			next_page = "J",
			prev_page = "K",
			under_cursor = "<cr>",

			-- In case you changed your mind, provide a keybind that lets you
			-- cancel the snipe and close the window.
			---@type string|string[]
			cancel_snipe = "<esc>",

			-- Close the buffer under the cursor
			-- Remove "j" and "k" from your dictionary to navigate easier to delete
			-- NOTE: Make sure you don't use the character below on your dictionary
			close_buffer = "D",

			-- Open buffer in vertical split
			open_vsplit = "V",

			-- Open buffer in split, based on `vim.opt.splitbelow`
			open_split = "H",

			-- Change tag manually (note only works if `persist_tags` is not enabled)
			-- change_tag = "C",
		},
		-- The default sort used for the buffers
		-- Can be any of:
		--  "last" - sort buffers by last accessed
		--  "default" - sort buffers by its number
		--  fun(bs:snipe.Buffer[]):snipe.Buffer[] - custom sort function, should accept a list of snipe.Buffer[] as an argument and return sorted list of snipe.Buffer[]
		---@type "last"|"default"|fun(buffers:snipe.Buffer[]):snipe.Buffer[]
		sort = "default",
	}
}
}
-- EL-MASTOR/bufferlist.nvim : It has delay whenever I open listed buffer, Why? I have no idea
-- wasabeef/bufferin.nvim : It really good, but some lags are existed and I cannot change j,k key
-- loath-dub/snipe.nvim : it is cool to navigate buffer but it doesn't support deleting visualized buffer
-- 						  or set shorcut key from dictionary only not first letter of file.
-- 						  or reorder buffer list
