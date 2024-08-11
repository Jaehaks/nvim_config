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
		enabled = true,
		lazy = true,
		ft = 'markdown',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		init = function ()
			vim.opt.conceallevel = 2 -- set conceallevel (but markdown.nvim will changes)
		end,
		config = function ()
			-- ####################################################
			-- * obsidian's setting
			-- ####################################################
			local obsidian = require('obsidian')
			obsidian.setup({
				workspaces = { -- this directory must exist
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
					img_name_func = function () -- download clipboard image to filename folder
						return string.format("%s\\%s-", vim.fn.expand('%:p:r'), os.date('%y%m%d'))
					end
				},
				ui = {
					enable = false, -- use markdown.nvim as renderer
				},
				note_id_func = function (title) -- set note id automatically when :ObsidianNew
					if title ~= nil then
						title = title:gsub(' ','-')
					end
					return tostring(os.date('%y%m%d')) .. '-' .. title
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
				-- check the terminal is wezterm
				if os.getenv('WEZTERM_PANE') == nil then
					vim.api.nvim_err_writeln('This terminal is not wezterm! Change Terminal')
				end

				-- get link under current cursor
				local line = vim.api.nvim_get_current_line() -- get current line string
				local col = vim.fn.col('.')
				local start_idx = 0
				local end_idx = 0
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

				-- check path is absolute
				local curdir = vim.fn.expand('%:p:h') -- get current buffer's dir
				local path = url
				path = path:gsub('/','\\') -- change for windows dir format
				if not CheckAbsolutePath(url) then
					path = curdir .. '\\' .. path
				end

				-- vim.api.nvim_command('silent !wezterm cli split-pane --horizontal -- cmd /k wezterm imgcat ' .. path .. ' ^& pause')
				vim.api.nvim_command('silent !wezterm cli split-pane --horizontal -- powershell wezterm imgcat ' .. '\'' ..  path .. '\'' .. ' ; pause')
				
				-- print(path)

				-- string.find(s, "%b[]") find start and end index with matching [ and ]
				-- string.find(s, "%b[]%b()") find pattern within [] followed by ()

			end
			
			vim.keymap.set('n', '<leader>mf', FollowImage                 , {noremap = true, desc = 'follow image link'})
			vim.keymap.set('n', '<leader>mv', '<Cmd>ObsidianPasteImg<CR>' , {noremap = true, desc = '(Obsidian)Paste Image From Clipboard'})
			vim.keymap.set('n', '<leader>mw', '<Cmd>ObsidianWorkspace<CR>', {noremap = true, desc = '(Obsidian)switch another workspace'})
			vim.keymap.set('n', '<leader>mn', '<Cmd>ObsidianNew<CR>'	  , {noremap = true, desc = '(Obsidian)Make new obsidian note'})
			vim.keymap.set('n', '<leader>mo', '<Cmd>ObsidianOpen<CR>'	  , {noremap = true, desc = '(Obsidian)Open a note in obsidian app'})
			-- ObsidianTOC() : use telescope-heading instead of it
			-- ObsidianQuickSwitch() : use oil or telescope instead of it
			--
			
		end
		-- BUG: img_name_func doesn't work
		-- obsidian's unique highlight works like ==word== in `workspace` only
	}
}

-- telekasten.nvim : setting filetype to telekasten is important to use telekasten's highlight
-- 					 but there are treesitter error when I set `auto_set_filetype`
