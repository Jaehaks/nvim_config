return {
	{
		'renerocksai/telekasten.nvim',
		enabled = false,
		dependencies = {'nvim-telescope/telescope.nvim'},
		config = function ()
			local telekasten = require('telekasten')
			local home_dir = vim.fn.expand('$HOME');
			home_dir = home_dir:gsub('\\','/');
			telekasten.setup({
				home = home_dir .. '/Telekasten_Notes',
				take_over_my_home = false,
				image_subdir = 'img',
				extension = '.md',
				image_link_style = 'markdown',
				tage_notation = '#tag',
				auto_set_filetype = false,
				auto_set_syntax = true,

			})
		end
	},
	{
		'epwalsh/obsidian.nvim',
		enabled = false,
		version = '*',
		lazy = true,
		ft = 'markdown',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		init = function ()
			vim.opt.conceallevel = 2 -- set conceallevel
		end,
		config = function ()
			local obsidian = require('obsidian')
			obsidian.setup({
				workspaces = {
					{
						name = 'personal',
						path = vim.fn.expand('$HOME') .. '\\Obsidian_Nvim\\personal'
					},
					{
						name = 'works',
						path = vim.fn.expand('$HOME') .. '\\Obsidian_Nvim\\works'
					}
				},
				mappings = {}, -- disable default keymapping
				preferred_link_style = 'markdown',
				attachments = {
					img_name_func = function () -- it doesn't work
						local client = obsidian.get_client()

						local note = client:current_note() 
						if note then
							-- return string.format("%s/imgs/", note.path)
							return string.format("%s/imgs/", note.path.filename)
						else
							return string.format("%s-", os.time())
						end
					end
				}
			})
			
		end
		-- BUG: img_name_func doesn't work
		-- obsidian's unique highlight works like ==word== in `workspace` only
	}
}

-- telekasten.nvim : setting filetype to telekasten is important to use telekasten's highlight
-- 					 but there are treesitter error when I set `auto_set_filetype`
