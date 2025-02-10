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
    branch = "1.0",
	keys = {
		{'<C-k>'},
		{'<C-j>'},
		{'<C-n>'},
		{'<C-n>'},
		{'<C-S-n>'},
		{'<C-b>'},
	},
	config = function()
		local mc = require("multicursor-nvim")

		mc.setup()

		-- Add cursors above/below the main cursor.
		vim.keymap.set({"n", "v"}, "<C-k>", function() mc.addCursor("k") end, {desc = '[Multicursor] Add below char'})
		vim.keymap.set({"n", "v"}, "<C-j>", function() mc.addCursor("j") end, {desc = '[Multicursor] Add above char'})
		vim.keymap.set({"n", "v"}, "<C-n>", function() mc.matchAddCursor(1) end, {desc = '[Multicursor] Add next cword'})
		vim.keymap.set({"n", "v"}, "<leader>q", function() mc.matchSkipCursor(1) end, {desc = '[Multicursor] Add next cword'})
		vim.keymap.set({"n", "v"}, "<C-S-n>", function() mc.matchAllAddCursors() end, {desc = '[Multicursor] Add all cword'})

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

		-- Add Current Cursor position | Deactivate multi-cursor mode
		vim.keymap.set({"n", "v"}, "<C-b>", function()
			if mc.cursorsEnabled() then
				mc.disableCursors()
			else
				mc.addCursor()
			end
		end, {desc = '[Multicursor] Add Current Pos | Deactivate'})

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
	end,
},
{
	-- multiple cursor : change string
	enabled = false,
	'mg979/vim-visual-multi',
	branch = 'master',
	event = 'VeryLazy',
	init = function ()
		vim.g.VM_default_mappings = 0 -- disable all keymaps except <C-n>  | it must be in init  field
		vim.g.VM_mouse_mappings = 0
		vim.g.VM_maps = {}
		vim.g.VM_maps = { -- these mappings are global. So keymaps acts anywhere
			['Find Under'] = '', -- disable <C-n>
								 -- user defined VM-Find-Under key is replaced by permanent command if it is in config field
								 -- it must be in init field to replace by user defined key
			-- ['Find Subword Under'] = '', -- it cannot be disabled (it is replaced by permanent key)
			['Select h'] = '<S-h>', -- visual select left
			['Select l'] = '<S-l>', -- visual select right
			['Toggle Mappings'] = '\\', -- toggle VM mode
		}
		vim.g.VM_add_cursor_at_post_no_mappings = 1
		vim.g.VM_verbose_commands = 1 --  not working
		vim.g.VM_silent_exit = 1 -- exit message not shown
		vim.g.VM_quit_after_leaving_insert_mode = 1 -- quit VM mode after leaving insert mode
	end,
	config = function ()

		-- TODO: toggle mapping / show inforline at once when visual-multi-cursor starts automatically
		-- @param Funkey <String> : String which is mapped to other function
		VMFunc = function (FunKey)
			local key = nil
			if vim.b[0].visual_multi then
				key = vim.api.nvim_replace_termcodes(FunKey, true, true, true)
				vim.api.nvim_feedkeys(key, 'n', false) -- execute plugin
			else
				key = vim.api.nvim_replace_termcodes(FunKey, true, true, true)
				vim.api.nvim_feedkeys(key, 'n', false) -- execute plugin
				key = vim.api.nvim_replace_termcodes('<Plug>(VM-Show-Infoline)', true, true, true)
				vim.api.nvim_feedkeys(key, 'n', false) -- show infoline at start

				if FunKey == '<Plug>(VM-Add-Cursor-At-Pos)' then
					key = vim.api.nvim_replace_termcodes('<Plug>(VM-Toggle-Mappings)', true, true, true)
					vim.api.nvim_feedkeys(key, 'n', false) -- escape visual-mutli mode at start
				end
			end
		end

		vim.keymap.set('n', '<C-b>'    , [[:lua VMFunc('<Plug>(VM-Add-Cursor-At-Pos)')<CR>]] , {silent = true})
		vim.keymap.set('n', '<C-k>'    , [[:lua VMFunc('<Plug>(VM-Add-Cursor-Down)')<CR>]]   , {silent = true})
		vim.keymap.set('n', '<C-j>'    , [[:lua VMFunc('<Plug>(VM-Add-Cursor-Up)')<CR>]]     , {silent = true})
		vim.keymap.set('n', '<C-n>'    , [[:lua VMFunc('<Plug>(VM-Find-Under)')<CR>]]        , {silent = true})
		-- vim.keymap.set('x', '<C-n>'    , [[:lua VMFunc('<Plug>(VM-Find-Subword-Under)')<CR>]], {silent = true})
			-- this key replaced by permanent command. so you do toggle-mappings manually
		vim.keymap.set('n', '<C-S-n>'  , [[:lua VMFunc('<Plug>(VM-Select-All)')<CR>]]        , {silent = true})

		-- additional keys
		-- q : disable selection under the cursor and go to next in VM mode
		-- Q : disable selection under the cursor and go to prev in VM mode
		-- TAB : cursor <-> extend mode switch
		-- o : switch direction of extending region
		-- 		selecting visual word is the same with extending after Find-Under

		-- how to use?
		-- 1) enter VM mode using <C-m> etc..
		-- 2) to move cursor freely, press  <leader>m
		-- 	  in this mode, you can add multicursor with key of VM mode like <C-m> etc..
		-- 	  but editing in VM mode cannot works
		-- 3) restore to VM mode, press <leader>m again.
		-- 4) edit the multi cursor region and exit with Esc
		-- Add <Plug>(VM-Show-Infoline) at the end of function to view whether cursor enters VM mode
		-- <Plug> function can be called only in keymap function
	end,
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
