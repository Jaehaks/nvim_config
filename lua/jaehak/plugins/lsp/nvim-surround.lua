return {
	-- mini-surround.nvim : only linewise, it has a bug that when a indent is ahead of word, surround inclueds the indent
	-- quick add/delete/change surrounding pairs
	'kylechui/nvim-surround',
	version = '*',
	event = 'VeryLazy',
	config = function ()
		require('nvim-surround').setup({
			keymaps = {
				insert          = "<C-g>s",
				insert_line     = "<C-g>S",
				normal          = "sa",		-- [linewise] ysiw"(word), ysl', yst;},(from current to jumpted location)
				normal_cur      = "sA",		-- [linewise] yss"  (current whole line)
				normal_line     = "sb",		-- [blockwise] ySiw"(word),
				normal_cur_line = "sB",		-- [blockwise] ySS" (current whole line), enter " above and below of cur line
				visual          = "sa",		-- [linewise] (v)S" left and right pairs of visual block
				visual_line     = "sb",		-- [blockwise] (v)gS" above and below pairs of visual block
				delete          = "sd",		-- delete
				change          = "sr",		-- change pairs and remain the linewise
				change_line     = "sR",		-- change pairs and move to blockwise

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
