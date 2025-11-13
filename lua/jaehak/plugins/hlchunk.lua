return {{
	-- show region of indentation block
	"shellRaining/hlchunk.nvim",
	ft = require('jaehak.core.paths').Filetypes.ForCode,
	opts = function ()
		local default_exclude_filetype = {
			dashboard           = true,
			TelescopePrompt     = true,
			help                = true,
			qf                  = true,
			gitcommit 			= true,
			yazi                = true,
			markdown            = true,
			text                = true,
		}
		return {
			chunk = { -- current chunk block using treesitter
				enable = true,
				duration = 0, -- animation time
				delay = 50, -- debounce filter
				exclude_filetypes = default_exclude_filetype,
			},
			indent = { -- show all indent
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
		}
	end
},
}
--	'lukas-reineke/indent-blankline.nvim' 		  -->>>> works well, not support current indentation level, it depends on treesitter
--	'nvimdev/indentmini.nvim' : loading time is fast, but not work
--  'echasnovski/mini.indentscope' : I think it is slower than hlchunk. and hlchunk's graphic is more good
--  'blink.indent' : author said it is blazing fast, but it doesn't reflect treesitter result,
--  				 There are overlapping functions with hlchunk
