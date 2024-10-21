return {
	-- display marks in signcolumn
	'chentoast/marks.nvim',
	config = function ()
		require('marks').setup({
			default_mappings = true,
			sign = true, -- show marks name in signcolumn
			-- force_write_shada = true -- deleting global marks update the shada file
				-- BUG: neovim has an issue that it cannot delete local marks
				-- setting 'force_write_shada' to true, `dm[a-z]` will works but `dm<space>` not works.
				-- set this flag will clear the shada file very often...
		})
	end
}
