local paths = require('jaehak.core.paths')
local utils = require('jaehak.core.utils')
return {
	{
		-- 'epwalsh/obsidian.nvim',
		'Jaehaks/obsidian.nvim',
		branch = 'fix/all',
		lazy = true,
		ft = 'markdown',
		opts = {
			workspaces = { -- this directory must exist
				{
					name = 'Personal',
					path = paths.obsidian.personal
				},
				{
					name = 'Project',
					path = paths.obsidian.project
				},
			},
			completion = {
				nvim_cmp  = false,
				blink     = true,
				min_chars = 2,
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
			picker = {
				name = 'snacks.pick',
				note_mappings = {
					new         = "<C-x>", -- Create a new note from your query.
					insert_link = "<C-l>", -- Insert a link to the selected note.
				},
				tag_mappings = {
					tag_note   = "<C-x>", -- Add tag(s) to current note.
					insert_tag = "<C-l>", -- Insert a tag at the current location.
				},
			}
		},
		config = function (_, opts)
			-- ####################################################
			-- * obsidian's setting
			-- ####################################################
			-- it need to use command
			local obsidian = require('obsidian')
			obsidian.setup(opts)

			-- register completion for blink.compat
			-- local cmp = require('cmp')
			-- cmp.register_source('obsidian', require('cmp_obsidian').new())
			-- cmp.register_source('obsidian_new', require('cmp_obsidian_new').new())
			-- cmp.register_source('obsidian_tags', require('cmp_obsidian_tags').new())


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
