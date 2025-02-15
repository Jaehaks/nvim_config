return {
	-- mini-surround.nvim : only linewise, it has a bug that when a indent is ahead of word, surround inclueds the indent
	-- quick add/delete/change surrounding pairs
	'kylechui/nvim-surround',
	version = '*',
	keys = {
		{'fa', mode = {'n', 'v'}},
		{'fA', mode = {'n', 'v'}},
		{'fb', mode = {'n', 'v'}},
		{'fB', mode = {'n', 'v'}},
		{'fd', mode = {'n', 'v'}},
		{'fr', mode = {'n', 'v'}},
		{'fR', mode = {'n', 'v'}},
	},
	opts = {
		keymaps = {
			-- insert / insert_line mode does not work
			normal          = "fa",		-- [linewise] ysiw"(word), ysl', yst;},(from current to jumpted location)
			normal_cur      = "fA",		-- [linewise] yss"  (current whole line)
			normal_line     = "fb",		-- [blockwise] ySiw"(word),
			normal_cur_line = "fB",		-- [blockwise] ySS" (current whole line), enter " above and below of cur line
			visual          = "fa",		-- [linewise] (v)S" left and right pairs of visual block
			visual_line     = "fb",		-- [blockwise] (v)gS" above and below pairs of visual block
			delete          = "fd",		-- delete
			change          = "fr",		-- change pairs and remain the linewise
			change_line     = "fR",		-- change pairs and move to blockwise

			-- all left ([<{  ==> add white space
			-- all right )}>] ==> not add white space
			-- difference pairs can apply in whole line wise condition,    yssi/<CR>\
			-- ysst  => for html tag
			-- 'b' to ')'   'B' to '}'    'r' to ']' 	in yss
			--
		},
		move_cursor = false, 				-- after surrounding operation, don't move cursor to beginning
	}
}
