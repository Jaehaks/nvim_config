return {
	-- mini-surround.nvim : only linewise, it has a bug that when a indent is ahead of word, surround inclueds the indent
	-- quick add/delete/change surrounding pairs
	'kylechui/nvim-surround',
	version = '*',
	init = function ()
		vim.g.nvim_surround_no_mappings = true
	end,
	keys = {
		{ "fa", "<Plug>(nvim-surround-normal)",          desc = "Add surround",                 mode = "n" },
		{ "fA", "<Plug>(nvim-surround-normal-cur)",      desc = "Add surround line",            mode = "n" },
		{ "fb", "<Plug>(nvim-surround-normal-line)",     desc = "Add surround (new line)",      mode = "n" },
		{ "fB", "<Plug>(nvim-surround-normal-cur-line)", desc = "Add surround line (new line)", mode = "n" },
		{ "fd", "<Plug>(nvim-surround-delete)",          desc = "Delete surround",              mode = "n" },
		{ "fr", "<Plug>(nvim-surround-change)",          desc = "Change surround",              mode = "n" },
		{ "fR", "<Plug>(nvim-surround-change-line)",     desc = "Change surround (new line)",   mode = "n" },
		{ "fa", "<Plug>(nvim-surround-visual)",          desc = "Add surround (visual)",        mode = 'x' },
		{ "fb", "<Plug>(nvim-surround-visual-line)",     desc = "Add surround line (visual)",   mode = 'x' },
	},
	opts = {
		-- insert / insert_line mode does not work
		-- normal [linewise] ysiw"(word), ysl', yst;},(from current to jumpted location)
		-- normal_cur [linewise] yss"  (current whole line)
		-- normal_line [blockwise] ySiw"(word),
		-- normal_cur_line [blockwise] ySS" (current whole line), enter " above and below of cur line
		-- visual [linewise] (v)S" left and right pairs of visual block
		-- visual line [blockwise] (v)gS" above and below pairs of visual block
		-- delete
		-- change pairs and remain the linewise
		-- change pairs and move to blockwise

		-- all left ([<{  ==> add white space
		-- all right )}>] ==> not add white space
		-- difference pairs can apply in whole line wise condition,    yssi/<CR>\
		-- ysst  => for html tag
		-- 'b' to ')'   'B' to '}'    'r' to ']' 	in yss
		--
		move_cursor = false, 				-- after surrounding operation, don't move cursor to beginning
	}
}
