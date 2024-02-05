return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'folke/neodev.nvim'
	},
	config = function()
		-- lua language server configuation
		local lspconfig = require('lspconfig')
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					completion = {
						callSnippet = 'Replace',	-- neodev.nvim completion
					},
					diagnostics = {
						globals = {'vim'},	-- recognize 'vim' global to language server
					}
				}
			}
		})

		-- autocmd key mapping when LspAttach
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
