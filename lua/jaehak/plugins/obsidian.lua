local paths = require('jaehak.core.paths')
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
			-- * Follow image link with wezterm
			-- ####################################################
			-- check extension of link is image
			local GetFileExtension = function (url)
				local image_ext_list = {'.bmp', '.jpg', '.jpeg', '.png', '.gif'}
				local ext = url:match('^.+(%..+)$')
				for _, val in ipairs(image_ext_list) do
					if ext == val then
						return true
					end
				end
				return false
			end

			local CheckAbsolutePath = function (url)
				local drive = string.find(url, '.:\\')
				if not drive then
					return false
				end
				return true
			end

			-- follow image link
			local FollowImage = function ()

				-- get link under current cursor
				local line = vim.api.nvim_get_current_line() -- get current line string
				local col = vim.fn.col('.')
				local start_idx, end_idx = 0, 0
				while true do
					start_idx, end_idx = string.find(line, '%b[]%b()', start_idx+1) -- get link format string
					-- if link doesn't exist
					if not start_idx then
						vim.api.nvim_err_writeln('Link doese not exist under the cursor!')
						return nil
					-- if link exists
					elseif start_idx <= col and col <= end_idx then
						break
					end
				end

				-- get file link and check that it is image
				local url = line:sub(start_idx, end_idx)
				start_idx, end_idx = string.find(url, '%b()')
				url = url:sub(start_idx+1, end_idx-1)
				if not GetFileExtension(url) then
					vim.api.nvim_command(':ObsidianFollowLink') -- if the link is not image, use obsidian's api
					-- vim.api.nvim_err_writeln('Link is not image!')
					return nil
				end

				-- check the terminal is wezterm (use wezterm for following image)
				if os.getenv('WEZTERM_PANE') == nil then
					vim.api.nvim_err_writeln('This terminal is not wezterm! Change Terminal')
				end

				-- check path is absolute
				local curdir = vim.fn.expand('%:p:h') -- get current buffer's dir
				local path = url
				path = path:gsub('/','\\') -- change for windows dir format
				if not CheckAbsolutePath(url) then
					path = curdir .. '\\' .. path
				end

				-- vim.api.nvim_command('silent !wezterm cli split-pane --horizontal -- cmd /k wezterm imgcat ' .. path .. ' ^& pause')
				vim.api.nvim_command('silent !wezterm cli split-pane --horizontal -- powershell wezterm imgcat ' .. '\'' ..  path .. '\'' .. ' ; pause')

				-- string.find(s, "%b[]") find start and end index with matching [ and ]
				-- string.find(s, "%b[]%b()") find pattern within [] followed by ()

			end



			-- ####################################################
			-- * ClipboardPaste
			-- ####################################################

			-- check content is URL form
			local is_url = function(content)
				return (string.match(content, '^(https?://)')
					 or string.match(content,'^(www%.)'))
			end

			-- paste with different form from system clipboard
			local ClipboardPaste = function ()

				-- check clipboard content
				local clipboard_content = vim.fn.getreg('+')

				-- Paste depends on format
				local markdown_link

				if is_url(clipboard_content) then -- paste with link form

					-- if visual mode, get the visualized word
					local link_name = ''
					local mode = vim.fn.mode()
					if mode == 'v' or mode == 'V' then -- if current mode is visual mode ('v') or line mode ('V')
						-- caution: getpos("'>") or getpos("'<") is updated after end of visual mode
						-- so use getpos('v') or getpos('.')
						local start_pos = vim.fn.getpos('v') -- get position of start of visual box
						local end_pos   = vim.fn.getpos('.') -- get position of end of visual box
						local txt       = vim.api.nvim_buf_get_text(0, start_pos[2]-1, start_pos[3]-1, end_pos[2]-1, end_pos[3], {})
						link_name       = table.concat(txt, '\n')
						markdown_link   = string.format('[%s](%s)',  link_name, clipboard_content)
						vim.api.nvim_buf_set_text(0, start_pos[2]-1, start_pos[3]-1, end_pos[2]-1, end_pos[3], {markdown_link})
						vim.api.nvim_input('<Esc>') -- go out to normal mode
					else
						markdown_link = string.format('[](%s)', clipboard_content)
						vim.api.nvim_put({markdown_link}, 'c', true, true)
					end

				elseif clipboard_content ~= '' then -- paste '+' register
					local termcodes = vim.api.nvim_replace_termcodes('"+p', true, false, true)
					vim.api.nvim_feedkeys(termcodes,'n', true)

				else -- paste with obsidian function
					vim.api.nvim_command('ObsidianPasteImg')

				end

			end

			local User_markdown2 = vim.api.nvim_create_augroup('User_markdown2', {clear = true})
			vim.api.nvim_create_autocmd('FileType',{
				group = User_markdown2,
				pattern = {'markdown'},
				callback = function ()
					vim.keymap.set({'n', 'v'}, 'P', ClipboardPaste, {buffer = 0, noremap = true, desc = 'Enhanced ClipboardPaste'})
				end
			})


			-- ####################################################
			-- * Keymaps
			-- ####################################################
			vim.keymap.set('n', '<leader>mf', FollowImage                      , {noremap = true, desc = 'follow image link'})
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
