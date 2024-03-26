return {
	'L3MON4D3/LuaSnip',
	lazy = true,
	build = vim.fn.has('win32') ~= 0 and 'make install_jsregexp' or nil,
	dependencies = {
		{
			'benfowler/telescope-luasnip.nvim',
			dependencies = {
				'nvim-telescope/telescope.nvim',
			},
			module = 'telescope._extensions.luasnip'
		}
	},
	config = function ()
		-- /////// configuration of luasnip //////////////
		local ls = require('luasnip')
		local types = require('luasnip.util.types')

		-- make custom highlight for luasnip
		vim.api.nvim_set_hl(0, 'LuasnipActive', {bg ='#2A4257', fg = '#CEA274'})

		ls.config.setup({
			-- history = true,
			-- update_events = {'TextChanged', 'TextChangedI'},
			ext_opts = { -- set highlight of snippet globally
				[types.insertNode] = {
					active = {hl_group = 'LuasnipActive'},
					passive = {hl_group = 'Visual'},
					visited = {hl_group = 'NONE'} -- restore highlight after edit
				},
				[types.choiceNode] = {
					active = {hl_group = 'LuasnipActive'},
					passive = {hl_group = 'Visual'},
					visited = {hl_group = 'NONE'} -- restore highlight after edit
				}
			}
		})

		------- keymaps ---------------
		-- setting keymaps in here will affect globally, you must write carefully

		------- autocmd ------------
		-- set autocmd to ulink snippet when cursor is out of the region
		local aug_LuasnipEnter = vim.api.nvim_create_augroup("LuasnipEnter", {clear = true})
		vim.api.nvim_create_autocmd("User", {
			group = aug_LuasnipEnter,
			pattern = "LuasnipInsertNodeEnter",
			callback = function()
				vim.g.id_LuasnipCheck = vim.api.nvim_create_autocmd("CursorMoved", {
					pattern = '*',
					callback = function ()
						if not ls.in_snippet() and ls.jumpable(1) and ls.jumpable(-1) then
							ls.unlink_current()
							vim.api.nvim_del_autocmd(vim.g.id_LuasnipCheck)
							vim.g.id_LuasnipCheck = nil
						end
					end
				})
			end
		})
		-- first : firstsecond : secondthird : third

		require('luasnip.loaders.from_lua').lazy_load({paths = './queries/LuaSnip'})

		-- /////// configuration of friendly-snippets //////////////
		-- ls.filetype_extend('lua', {'luadoc'})
		-- ls.filetype_extend('matlab', {'matlab'})
		-- require('luasnip.loaders.from_vscode').load({paths = "c:\\Users\\7106704\\.config\\nvim\\query\\friendly-snippets\\matlab"})
		-- require('luasnip.loaders.from_vscode').lazy_load()

	end
}
