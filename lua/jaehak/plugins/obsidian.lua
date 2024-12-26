local paths = require('jaehak.core.paths')
local utils = require('jaehak.core.utils')
return {
	{
		-- 'epwalsh/obsidian.nvim',
		'Jaehaks/obsidian.nvim',
		lazy = true,
		ft = 'markdown',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		init = function ()
			-- vim.opt.conceallevel = 2 -- set conceallevel (but markdown.nvim will changes)
		end,
		config = function ()
			-- ####################################################
			-- * obsidian's setting
			-- ####################################################
			local obsidian = require('obsidian')
			obsidian.setup({
				workspaces = { -- this directory must exist
					{
						name = 'Personal',
						path = paths.obsidian.personal
					},
				},
				mappings = {}, -- disable default keymapping
				new_notes_location = 'current_dir',
				preferred_link_style = 'markdown',
				follow_url_func = function (url) -- command for follow url
					vim.fn.system('start ' .. url)
				end,
				attachments = {
					confirm_img_paste = false,  -- show confirm message when paste
					img_folder = '', 			-- use path with img_name_func only
					img_name_func = function () -- download clipboard image to filename folder
						return string.format("%s\\%s-", vim.fn.expand('%:p:r'), os.date('%y%m%d'))
					end,
					img_text_func = function (client, path)
						-- path : absolute path of image file
						-- client:vault_relative_path(path) : relative to vault

						-- set link name with relative to current file path not vault
						path = path:relative_to(vim.fn.expand('%:p:h'))
						return string.format("![%s](%s)", path.name, path)
					end
				},
				ui = {
					enable = false, -- use markdown.nvim as renderer
					checkboxes = {
						[" "] = { char = "", hl_group = 'ObsidianTodo'},
						["x"] = { char = "󰄲", hl_group = 'ObsidianDone'},
						["-"] = { char = "󱋭"},
					}
				},
				note_id_func = function (title) -- set note id automatically when :ObsidianNew
					if title == nil then
						title = 'NewFile'
					else
						title = title:gsub(' ','_')
						-- Having whitespace in title and id works well when I search string or open file.
						-- But if title has whitespace, ' ' must be changed with %20 to insert link.
					end
					-- return tostring(os.date('%y%m%d')) .. '_' .. title
					return title
				end,
			})



			-- ####################################################
			-- * Keymaps
			-- ####################################################
			--
			local User_markdown2 = vim.api.nvim_create_augroup('User_markdown2', {clear = true})
			-- set clipboardPaste keymap for only markdown
			vim.api.nvim_create_autocmd('FileType',{
				group = User_markdown2,
				pattern = {'markdown'},
				callback = function ()
					vim.keymap.set({'n', 'v'}, 'P', utils.ClipboardPaste, {buffer = 0, noremap = true, desc = 'Enhanced ClipboardPaste'})
					vim.keymap.set('n', 'gf', utils.FollowLink , {buffer = 0, noremap = true, desc = 'follow image link'})
					vim.keymap.set('n', 'gd', utils.GotoCursor,  {buffer = 0, noremap = true, desc = '(Obsidian)open file in floating window'})
				end
			})

			-- vim.keymap.set('n', '<leader>mf', utils.FollowLink                      , {noremap = true, desc = 'follow image link'})
			vim.keymap.set('n', '<leader>mv', '<Cmd>ObsidianPasteImg<CR>'      , {noremap = true, desc = '(Obsidian)Paste Image From Clipboard'})
			vim.keymap.set('n', '<leader>mw', '<Cmd>ObsidianWorkspace<CR>'     , {noremap = true, desc = '(Obsidian)switch another workspace'})
			vim.keymap.set('n', '<leader>ms', '<Cmd>ObsidianQuickSwitch<CR>'   , {noremap = true, desc = '(Obsidian)Switch another file'})
			vim.keymap.set('n', '<leader>mn', '<Cmd>ObsidianNew<CR>'           , {noremap = true, desc = '(Obsidian)Make new obsidian note'})
			vim.keymap.set('n', '<leader>mo', '<Cmd>ObsidianOpen<CR>'          , {noremap = true, desc = '(Obsidian)Open a note in obsidian app'})
			vim.keymap.set('n', '<C-c>'		, '<Cmd>ObsidianToggleCheckbox<CR>', {noremap = true, desc = '(Obsidian)Toggle checkbox'})
			-- ObsidianTOC() : use telescope-heading instead of it
			-- ObsidianQuickSwitch() : it can be replaced with oil or telescope,
			-- 						   but, this func can add file link directly

		end
		-- BUG: img_name_func doesn't work
		-- obsidian's unique highlight works like ==word== in `workspace` only
	}
}

-- telekasten.nvim : setting filetype to telekasten is important to use telekasten's highlight
-- 					 but there are treesitter error when I set `auto_set_filetype`
