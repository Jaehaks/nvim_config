return {
{
	-- multiple cursor : change string
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
