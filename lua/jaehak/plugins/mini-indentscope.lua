return {
	-- support current indentation only(good), but if there are code in indentline, the line will be  cut
	'echasnovski/mini.indentscope',
	enabled = true,
	version = '*',
	event = {'BufReadPost', 'BufNewFile'},
	config = function()
		local indents = require('mini.indentscope')
		indents.setup({
			draw = {
				delay = 0,
				animation = indents.gen_animation.none(),	-- function return 0
			},
		})

		-- Disable for certain filetypes
		vim.api.nvim_create_autocmd({'FileType'},{
			desc = 'disable indentscope for certain filetypes',
			callback = function()
				local ignore_filetype = { 'help', 'lazy', 'lir', 'TelescopePrompt', 'mason', 'toggleterm', 'Trouble' }
				if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
					vim.b[0].miniindentscope_disable = true		-- if use b (buffer) variable,   set b[buf_id]
				end
			end,
		})
	end
}
--	'lukas-reineke/indent-blankline.nvim' 		  -->>>> works well, not support current indentation level, it depends on treesitter 
