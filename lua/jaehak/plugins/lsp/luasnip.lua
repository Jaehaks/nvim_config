return {
	'L3MON4D3/LuaSnip',
	version = 'v2.*',
	lazy = true,
	-- I failed to link when using make, use other way like luarocks
	-- build = vim.fn.has('win32') ~= 0 and 'make install_jsregexp' or nil,
	config = function ()
		-- /////// configuration of luasnip //////////////
		local ls = require('luasnip')
		local types = require('luasnip.util.types')

		ls.config.setup({
			update_events = {'TextChanged', 'TextChangedI'}, -- make snippet update whenever key change (default : insertleave)
			enable_autosnippets = true, --  set autosnippet for autosnippet tables
			ext_opts = { -- set highlight of snippet globally
				[types.insertNode] = {
					passive = {hl_group = 'Visual'},
					visited = {hl_group = 'NONE'} -- restore highlight after edit
				},
				[types.choiceNode] = {
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

		-- load luasnip queries, snippets in [filetype].lua apply to each filetype
		require('luasnip.loaders.from_lua').lazy_load({paths = './queries/LuaSnip'})
	end
}
