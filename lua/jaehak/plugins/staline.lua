return {
{
	'tamton-aquib/staline.nvim',
	-- lazy = false,
	dependencies = {
		'Jaehaks/bufman.nvim',
	},
	event = 'BufReadPre',
	init = function ()
		vim.opt.laststatus = 2
		vim.opt.showtabline = 0
		vim.opt.termguicolors = true
	end,
	opts = function ()
		local util = require("staline.utils")
		local bufman = require('bufman')
		return {
			defaults = {
				line_column = '[%l/%L]:%c', -- line/total : column
				mod_symbol = '[+]',
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
				mid = {
					-- function() return vim.o.modified and '[+]' or '' end,
					{'StalineYellow', 'f_modified'},
					' ',
					{'Staline', 'f_icon'},
					' ',
					{'Staline', 'f_name'},
					' ',
					'lsp'
				},
				right = {
					function() return vim.bo[0].fileencoding .. ' ' end ,
					' ',
					function() return vim.api.nvim_get_current_buf() .. ':' .. bufman.get_bufcount() end,
					'  ',
					function() return vim.bo[0].filetype end,
					'right_sep_double',
					'-line_column'
				}
			},
			special_table = nil,
		}
	end,
	config = function (_, opts)

		-- ///////// status line configuration /////////////
		require('staline').setup(opts)

		-- ///////// buffer line configuration /////////////
		-- require('stabline').setup({
		-- 	style = 'slant', -- it set stab_left / stab_right using preset
		-- 	stab_right = "",
		-- 	fg = '#000000',
		-- 	bg = '#986fec',
		-- 	inactive_fg = '#AAAAAA',
		-- 	exclude_fts = {'dashboard', 'Outline'},
		-- 	numbers = function (bufn,n)
		-- 		return bufn .. ' ' -- show buffer number
		-- 	end
		-- })

		vim.api.nvim_set_hl(0, "StalineBranch"  	 , { fg = '#FF00FF'})
		vim.api.nvim_set_hl(0, "StalineFileSize"  	 , { fg = '#FFD800'})
		vim.api.nvim_set_hl(0, "StalineYellow"  	 , { fg = '#FFFF00'})

	end
},
}
-- staline.nvim : blazed fast loading time, it covers both statusline and tabline and very flexible/configurable supports
-- 				  it doesn't support dynamic rendering of bufferline when too many buffers are listed
-- lualine/bufferline : bufferline has a bug to configure highlight, both have long load time
-- heirline.nvim : it can be more powerful, but lualine has more simple way to configure the same configuration.
-- romgrk/barbar.nvim : it has many feature what is want. but 'nvim_cokeline' is more configurable
-- 						and has faster loading time a half of barbar.nvim
--
-- 'willothy/nvim-cokeline' : it's loading time is very fast, This is a plugin I've been using for a long time.
-- 							  But I decided to erase the buffer line for a more wider screen using buffer manager
-- 							  the keymapping to swap buffer using character and prev/next buffer is replaced to bufman.nvim
