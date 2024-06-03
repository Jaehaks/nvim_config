return {
{
	'tamton-aquib/staline.nvim',
	lazy = false,
	init = function ()
		vim.opt.laststatus = 2
		vim.opt.showtabline = 2
		vim.opt.termguicolors = true
	end,
	config = function ()
		local util = require("staline.utils")

		-- ///////// status line configuration /////////////
		require('staline').setup({
			defaults = {
				line_column = '[%l/%L]:%c', -- line/total : column
				mod_symbol = '',
				lsp_client_symbol = '',
				true_colors = true, -- show lsp true color
			},
			mode_icons = {
				n = 'NORMAL',
				no = 'PENDING-C',
				nov = 'PENDING-L',
				noV = 'PENDING-B',
				niI = 'EXECUTE-I',
				niR = 'EXECUTE-R',
				niV = 'EXECUTE-VR',
				i = 'INSERT',
				ic = 'COMPLETE-G',
				ix = 'COMPLETE-X',
				s = 'SELECT',
				S = 'SELECT',
				r = 'REPLACE',
				['r?'] = 'REPLACE',
				R = 'REPLACE',
				c = 'COMMAND',
				v = 'VISUAL',
				V = 'VISUAL-L',
				t = 'TERMINAL',
				['!'] = 'SHELL',
			},
			sections = {
				left = {'- ', '-mode', 'left_sep_double',
						{'StalineFileSize','file_size'},
						{'StalineBranch','branch'} },
				mid = {{'Normal', 'file_name'},
						'lsp'},
				right = {function() return  vim.bo[0].fileencoding .. ' ' end , '',
						'cool_symbol', ' ',
						function() return util.get_file_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e')) .. ' ' .. vim.bo[0].filetype end,
						'right_sep_double', '-line_column'}
		},
		special_table = nil,
		})

		-- ///////// buffer line configuration /////////////
		require('stabline').setup({
			style = 'slant', -- it set stab_left / stab_right using preset
			stab_right = "",
			fg = '#000000',
			bg = '#986fec',
			inactive_fg = '#AAAAAA',
			exclude_fts = {'dashboard', 'Outline'},
			numbers = function (bufn,n)
				return bufn .. ' ' -- show buffer number
			end
		})

		vim.api.nvim_set_hl(0, "StalineBranch"  	 , { fg = '#FF00FF'})
		vim.api.nvim_set_hl(0, "StalineFileSize"  	 , { fg = '#FFD800'})

	end
}
}
-- staline.nvim : blazed fast loading time, it covers both statusline and tabline and very flexible/configurable supports
-- lualine/bufferline : bufferline has a bug to configure highlight, both have long load time
-- heirline.nvim : it can be more powerful, but lualine has more simple way to configure the same configuration.  
