return {
{
	-- "brenton-leighton/multiple-cursors.nvim",
	"Jaehaks/multiple-cursors.nvim",
	enabled = false,
	version = "*",  -- Use the latest tagged version
	config = function ()

		vim.api.nvim_set_hl(0, 'MultipleCursorsCursor'    , { fg = 'black', bg = "#F78C6C" })
		vim.api.nvim_set_hl(0, 'MultipleCursorsVisual'    , { bg = "#647B13" })
		vim.api.nvim_set_hl(0, "MultipleCursorsLockCursor", { fg = 'black', bg = "#955441" })


		local mc = require('multiple-cursors')
		local mc_motion = require('multiple-cursors.normal_mode.motion')
		mc.setup({
			custom_key_maps = {
				{{'n', 'x'}, {'j', '<Up>'}, mc_motion.k},
				{{'n', 'x'}, {'k', '<Down>'}, mc_motion.j},
				{{'n', 'x'}, {'<leader>a'}, mc.align},
			},
			pre_hook = function ()
				vim.opt.cursorline = false
				vim.print('Multiple Cursor Mode!!')
			end,
			post_hook = function ()
				vim.opt.cursorline = true
				vim.print('')
			end
		})

		vim.keymap.set({'n', 'x'}, '<C-k>',  "<Cmd>MultipleCursorsAddDown<CR>", {desc = 'Add cursor and move down'} )
		vim.keymap.set({'n', 'x'}, '<C-j>',  "<Cmd>MultipleCursorsAddUp<CR>", {desc = 'Add cursor and move Up'} )
		vim.keymap.set({'n', 'x'}, '<C-S-n>',  "<Cmd>MultipleCursorsAddMatches<CR>", {desc = 'Add cursor to cword'} )
		vim.keymap.set({'n', 'x'}, '<C-n>',  "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", {desc = 'Add cursor and jump to next cword'} )
		vim.keymap.set({'n', 'x'}, '<C-q>',  "<Cmd>MultipleCursorsJumpNextMatch<CR>", {desc = 'Jump to next cword'} )
		vim.keymap.set({'n', 'x'}, '<leader>l',  "<Cmd>MultipleCursorsLock<CR>", {desc = 'Toggle lock virtual cursors'} )
	end,
},
{
	"jake-stewart/multicursor.nvim",
	enabled = true,
	lazy = true,
    branch = "1.0",
	keys = {
		{'<C-k>', function () require("multicursor-nvim").addCursor('k') end, desc = '[Multicursor] Add below char', mode = {'n', 'v'}},
		{'<C-j>', function () require("multicursor-nvim").addCursor('j') end, desc = '[Multicursor] Add above char', mode = {'n', 'v'}},
		{'<C-n>', function () require("multicursor-nvim").matchAddCursor(1) end, desc = '[Multicursor] Add next cword', mode = {'n', 'v'}},
		{'<C-S-n>', function () require("multicursor-nvim").matchAllAddCursors() end, desc = '[Multicursor] Add all cword', mode = {'n', 'v'}},
		{'<C-b>', function ()
			local mc = require('multicursor-nvim')
			if mc.cursorsEnabled() then
				mc.disableCursors()
			else
				mc.addCursor()
			end
		end, desc = '[Multicursor] Add Current Pos | Deactivate', mode = {'n', 'v'}},
	},
	opts = function ()
		local mc = require("multicursor-nvim")

		vim.keymap.set({"n", "v"}, "<leader>q", function() mc.matchSkipCursor(1) end, {desc = '[Multicursor] Add next cword'})

		-- Rotate the main cursor within multi-cursors
		vim.keymap.set({"n", "v"}, "<C-l>", function ()
			if mc.cursorsEnabled() then
				mc.nextCursor()
			end
		end, {desc = '[Multicursor] move main cursor within multi-cursors'})

		-- Delete the current main cursor.
		vim.keymap.set({"n", "v"}, "<C-q>", function ()
			if mc.cursorsEnabled() then
				mc.deleteCursor()
			end
		end, {desc = '[Multicursor] Delete Current Pos'})

		-- Lock Cursor
		vim.keymap.set({"n"}, "<leader>l", function()
			if mc.cursorsEnabled() then
				mc.disableCursors()
			else
				mc.enableCursors()
			end
		end, {desc = '[Multicursor] Toggle lock of the cursor'})

		-- Quit multicursor mode
		vim.keymap.set("n", "<esc>", function()
			if mc.hasCursors() then
				mc.clearCursors()
			else
			end
		end, {desc = '[Multicursor] quit multicursor mode'})

		-- Align cursor columns.
		vim.keymap.set("n", "<leader>a", function ()
			if mc.cursorsEnabled() then
				mc.alignCursors()
			end
		end, {desc = '[Multicursor] align columns of cursor'})

		-- Append/insert for each line of visual selections.
		vim.keymap.set("v", "I", mc.insertVisual, {desc = '[Multicursor] Add multicursor at Start in visual block'})
		vim.keymap.set("v", "A", mc.appendVisual, {desc = '[Multicursor] Add multicursor at End in visual block'})

		-- match new cursors within visual selections by regex.
		vim.keymap.set("v", "M", mc.matchCursors, {desc = '[Multicursor] Add multicursor to start of matching pattern'})

		-- Customize how cursors look.
		vim.api.nvim_set_hl(0, "MultiCursorCursor"          , { fg = 'black', bg = "#F78C6C" }) -- cursor color when multicursor enabled
		vim.api.nvim_set_hl(0, "MultiCursorVisual"          , { bg = "#647B13" }) -- cursor color when multicursor enabled
		vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor"  , { fg = 'black', bg = "#955441" }) -- cursor color when multicursor paused
		vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual"  , { bg = "#5C533B" }) -- cursor color when multicursor enabled

		return {}
	end
},
}
-- 'smoka7/multicursors.nvim' : it doesn't support 'Add-Cursor-At-Post', sometimes it invokes autocmd error
-- 								it has little buggy and lag
-- 'mg979/vim-visual-multi' : After entering visual-multi mode, keymap related with <CR> is cleared
-- 							  It seems to bug. It is the reason Why I change to 'jake-stewart/multicursor.nvim'
-- "brenton-leighton/multiple-cursors.nvim", : very precise, but it is too buggy and cannot enter autoclose ()
-- "jake-stewart/multicursor.nvim", : it is nice to use. it doesn't support synchronizing when entering characters
-- 									  but I know why this is hard to implement.
-- 									  it is also has a bug that the cursor is gone to the top when undo after align
