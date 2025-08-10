return {
{
	'tamton-aquib/staline.nvim',
	-- lazy = false,
	event = 'BufReadPre',
	init = function ()
		vim.opt.laststatus = 2
		vim.opt.showtabline = 2
		vim.opt.termguicolors = true
	end,
	opts = function ()
		local util = require("staline.utils")
		return {
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
				mid = {{'Staline', 'file_name'},
				'lsp'},
				right = {function() return  vim.bo[0].fileencoding .. ' ' end , '',
				'cool_symbol', ' ',
				function() return util.get_file_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e')) .. ' ' .. vim.bo[0].filetype end,
				'right_sep_double', '-line_column'}
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

	end
},
{
	-- bufferline
	'willothy/nvim-cokeline',
	event = 'BufReadPre',
	keys = {
		{'<leader>bp', function () require('cokeline.mappings').pick('focus') end		, desc = '[Cokeline] pick a buffer'},
		{'<M-m>'     , ']b' , desc = 'go to next buffer'},
		{'<M-n>'     , '[b' , desc = 'go to previous buffer'},
	},
	opts = function ()
		vim.api.nvim_set_hl(0, "BufferActive", { bg = "#986FEC", fg = "#000000" })
		vim.api.nvim_set_hl(0, "BufferInActive", { bg = "#131313", fg = "#AAAAAA" })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#131313"}) -- fill color remained region of tabline

		local is_picking_focus = require('cokeline.mappings').is_picking_focus
		local is_picking_close = require('cokeline.mappings').is_picking_close
		local get_hex = require('cokeline.hlgroups').get_hl_attr
		local cokeline = require('cokeline')

		local red = vim.g.terminal_color_1
		-- local yellow = vim.g.terminal_color_3

		return {
			mappings = {
				cycle_prev_next = false, -- don't cycle when focus/switch
				disable_mouse = false,
			},
			history = {
				enabled = false,
			},
			default_hl = {
				fg = function (buffer)
					return buffer.is_focused and get_hex('BufferActive', 'fg') or get_hex('BufferInActive', 'fg')
				end,
				bg = function (buffer)
					return buffer.is_focused and get_hex('BufferActive', 'bg') or get_hex('BufferInActive', 'bg')
				end
			},
			pick = {
				use_filename = true, -- use first char of filename when pick
			},
			fill_hl = 'TabLineFill', -- remained region color
			components = {
				{ -- separator
					text = " ",
					fg = get_hex('BufferInActive', 'bg')
				},
				{
					text = function (buffer)
						return buffer.number .. ' '
					end
				},
				{ -- icon or picking char
					text = function(buffer)
						return
						(is_picking_focus() or is_picking_close())
						and buffer.pick_letter .. ' '
						or buffer.devicon.icon
					end,
					fg = function(buffer)
						return
						(is_picking_focus() and '#31EC36')
						or (is_picking_close() and red)
						or buffer.devicon.color
					end,
				},
				{ -- filename with unique prefix
					text = function(buffer)
						return buffer.unique_prefix .. buffer.filename .. ' '
					end,
					bold = function(buffer) return buffer.is_focused end,
				},
				{
					text = function (buffer)
						return buffer.is_modified and '' or ' '
					end,
					fg = get_hex('BufferActive', 'fg')
				},
				{
					text = "",
					fg = function (buffer)
						return buffer.is_focused and get_hex('BufferActive', 'bg') or get_hex('BufferInActive', 'bg')
					end,
					bg = get_hex('BufferInActive', 'bg'),
				},
			}
		}
	end
	},
}
-- staline.nvim : blazed fast loading time, it covers both statusline and tabline and very flexible/configurable supports
-- 				  it doesn't support dynamic rendering of bufferline when too many buffers are listed
-- lualine/bufferline : bufferline has a bug to configure highlight, both have long load time
-- heirline.nvim : it can be more powerful, but lualine has more simple way to configure the same configuration.
-- romgrk/barbar.nvim : it has many feature what is want. but 'nvim_cokeline' is more configurable
-- 						and has faster loading time a half of barbar.nvim
