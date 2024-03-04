return {
	-- quick add/delete/change surrounding pairs
	'kylechui/nvim-surround',
	version = '*',
	event = 'VeryLazy',
	config = function ()
		require('nvim-surround').setup({
			keymaps = {
				insert          = "<C-g>s",
				insert_line     = "<C-g>S",
				normal          = "ys",			-- [linewise] ysiw"(word), ysl', yst;},(from current to jumpted location)
				normal_cur      = "yss",		-- [linewise] yss"  (current whole line)
				normal_line     = "yS",			-- [blockwise] ySiw"(word),  
				normal_cur_line = "ySS",		-- [blockwise] ySS" (current whole line), enter " above and below of cur line 
				visual          = "S",			-- [linewise] (v)S" left and right pairs of visual block
				visual_line     = "gS",			-- [blockwise] (v)gS" above and below pairs of visual block
				delete          = "ds",			-- delete 
				change          = "cs",			-- change pairs and remain the linewise
				change_line     = "cS",			-- change pairs and move to blockwise

				-- all left ([<{  ==> add white space 
				-- all right )}>] ==> not add white space 
				-- difference pairs can apply in whole line wise condition,    yssi/<CR>\   
				-- ysst  => for html tag 
				-- 'b' to ')'   'B' to '}'    'r' to ']' 	in yss
				--
			},
			move_cursor = false, 				-- after surrounding operation, don't move cursor to beginning
		})
	end
}
