return {
	'neovim/nvim-lspconfig',
--	enabled = false,
	ft = {'lua', 'matlab'},		-- nvim-lspconfig must be loaded after than mason. If not, spawning server warning fired
	dependencies = {
--		'folke/neodev.nvim',
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		-- setup neodev configuration 
--		require('neodev').setup({
--			setup_jsonls = false,
--			override = function(root_dir, library)
--				library.enabled = true
--				library.plugins = true
--			end,
--		})

		local lspconfig = require('lspconfig')
		local lsp_util = require('lspconfig.util')
		local capabilities = require('cmp_nvim_lsp').default_capabilities()

		-- ####### 1) lua language server configuation #########
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
--					completion = {
--						callSnippet = 'Replace',	-- neodev.nvim completion
--					},
					diagnostics = {
--						enable = true,
						globals = {'vim'},	-- recognize 'vim' global to language server
					},
					workspace = {
						library = {
							vim.env.VIMRUMTIME,
							--vim.api.nvim_get_runtime_file('',true),

							-- ## below two directory make lsp loading too slow 
							-- I think stdpath('data') load all plugins even though it has "enabled = false"
--							vim.fn.stdpath('config'),
--							vim.fn.stdpath('data'),
						}
					}
				}
			},
			capabilities = capabilities
		})

		lspconfig.matlab_ls.setup({
			cmd = {'matlab-language-server', '--stdio'},
			filetypes = {'matlab'},
			root_dir = lsp_util.root_pattern('*.m'),
			settings = {
				matlab = {
					indexWorkspace = true,
					installPath = 'C:\\Program Files\\MATALB\\R2018a',
					matlabConnectionTiming = 'onStart',
					telemetry = true,
				},
				single_file_support = true,
			}
		})

		-- ####### autocmd key mapping when LspAttach ######
		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'lsp keybindings when on_attach',
			callback = function()
				local opts = {buffer = true}
				vim.keymap.set('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<cr>', opts)	-- hover current line funciton
				vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<cr>', opts)				-- hover current cursor item
				vim.keymap.set('n', 'gD', ':lua vim.lsp.buf.type_definition()<cr>', opts)	-- type def
				vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', opts)		-- function / var def
				vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.reference()<cr>', opts)			-- function / var ref
			end
		})

		-- global mapping for diagnostic
		vim.keymap.set('n', 'go', vim.diagnostic.open_float)			-- float diagnostic result, not nex the line
		vim.keymap.set('n', '[o', vim.diagnostic.goto_prev)
		vim.keymap.set('n', ']o', vim.diagnostic.goto_next)

		-- other
		-- 	vim.lsp.buf.code.action  => change parameter order 

		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics, {
				virtual_text = false
			}
		)
	end
}
