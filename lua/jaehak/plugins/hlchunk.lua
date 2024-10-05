return {{
	-- support current indentation only(good), but if there are code in indentline, the line will be  cut
	'echasnovski/mini.indentscope',
	enabled = false,
	version = '*',
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
				local ignore_filetype = { 'help', 'lazy', 'TelescopePrompt', 'mason', 'Trouble', 'dashboard', 'Oil' , 'NeogitStatus', 'grapple'}
				if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
					vim.b[0].miniindentscope_disable = true		-- if use b (buffer) variable,   set b[buf_id]
				end
			end,
		})
	end
},
{
	"shellRaining/hlchunk.nvim",
	enabled = true,
	config = function()
		local default_exclude_filetype = {
			dashboard           = true,
			TelescopePrompt     = true,
			help                = true,
			qf                  = true,
			NeogitCommitMessage = true,
			yazi                = true,
		}
		require("hlchunk").setup({
			chunk = {
				enable = true,
				exclude_filetypes = default_exclude_filetype,
			},
			indent = {
				enable = false,
				exclude_filetypes = default_exclude_filetype,
			},
			line_num = {
				enable = false,
				exclude_filetypes = default_exclude_filetype,
			},
			blank = {
				enable = false,
				exclude_filetypes = default_exclude_filetype,
			}
		})
	end
}
}
--	'lukas-reineke/indent-blankline.nvim' 		  -->>>> works well, not support current indentation level, it depends on treesitter
--	'nvimdev/indentmini.nvim' : loading time is fast, but not work
