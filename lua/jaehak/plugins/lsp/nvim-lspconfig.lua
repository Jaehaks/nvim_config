return {
	'neovim/nvim-lspconfig',
	-- lazy = true,		-- nvim-lspconfig must be loaded after than mason. If not, spawning server warning fired
	dependencies = {
		{
			'folke/neodev.nvim',
			ft = {'lua'}
		},
		'hrsh7th/cmp-nvim-lsp',
		'williamboman/mason.nvim',	-- to recognize language server ahead of lspconfig
	},
	config = function()
		-- ######## setup neodev configuration, must be start #######
		-- feature : vim object completion / require completion
		require('neodev').setup({
			setup_jsonls = false,
			library = {
				enabled = true,
				runtime = true,			-- runtime path
				types = true,			-- vim.api / vim.lsp completion
				plugins = false,		-- installed plugins completion (too long loading time)
			}
		})

		local lspconfig = require('lspconfig')
		local lsp_util = require('lspconfig.util')
		local capabilities = require('cmp_nvim_lsp').default_capabilities()


		-- ####### 1) lua language server configuration #########
		lspconfig.lua_ls.setup({
			settings = {	-- settings of lua_ls document
				Lua = {
					completion = {
						callSnippet = 'Replace',	-- neodev.nvim completion
					},
					diagnostics = {
						disable = {
							'missing-parameter',	-- disable diagnostics about whether all fields are filled
						},
						globals = {'vim'},	-- recognize 'vim' global to language server
						undefined_global = false,
					},
					workspace = {
						library = {
							vim.env.VIMRUMTIME,
							--vim.api.nvim_get_runtime_file('',true),

							-- ## below two directories make lsp loading too slow 
							-- I think stdpath('data') load all plugins even though it has "enabled = false"
--							vim.fn.stdpath('config'),
--							vim.fn.stdpath('data'),
						}
					}
				}
			},
			capabilities = capabilities
		})

		-- ####### 2) matlab language server configuration #########
		lspconfig.matlab_ls.setup({
			cmd = {'matlab-language-server', '--stdio'},
			filetypes = {'matlab'},
			root_dir = lsp_util.root_pattern('*.m'),
			settings = {
				matlab = {
					indexWorkspace = true,
					installPath = 'C:\\Program Files\\MATALB\\R2023b',
					matlabConnectionTiming = 'onStart',
					telemetry = true,
				},
			},
			single_file_support = true,
		})

		-- ####### 3) markdown language server configuration #########
		-- marksman offers very few features. It does not useful as I think. I don't use link works heavily
		-- lspconfig.marksman.setup({
		-- 	cmd = {'marksman', 'server'},
		-- 	filetypes = {'markdown', 'markdown.mdx'},
		-- 	root_dir = lsp_util.root_pattern('*.md'),
		-- 	single_file_support = true,
		-- })


		-- ####### 5) ltex language server configuration #########
		-- it need java11(upper class file 55). => scoop install openjdk11
		-- it works, but the grammar check level is poor I thought and cannot apply by context
		-- ltex server does offline operation
		-- ltex only comment check in program language 
		lspconfig.ltex.setup({
			cmd = {'ltex-ls'},
			settings = {
				ltex = {
					-- both 'enabled' and 'filetypes' are listed to check
					enabled = {'gitcommit', 'markdown', 'text', 'NeogitCommitMessage', 'lua'},
					language = 'en-US',
					disabledRules = {
						['en-US'] = {
							'MORFOLOGIK_RULE_EN_US',	-- misspell check
							'WHITESPACE_RULE',			-- check white space in front of line
						}
					}
				}
			},
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
			filetypes = {'gitcommit', 'markdown', 'text', 'NeogitCommitMessage', 'lua'},
			single_file_support = true,
		})
		-- grammar-guard.nvim : deprecated
		-- prosesitter : deprecated


		-- ####### 6) texlab language server configuration - for latex #########
		-- install : miktex for latexmk
		-- install : sumatraPDF for viewer, and add to user path 
		-- texlab does not support code action. and it is not compatible with lspsaga. 
		-- lspsaga's function makes error. use default vim.lsp function
		
		lspconfig.texlab.setup({
			cmd = {'texlab'},
			filetypes = {'tex', 'plaintex'},
			settings = {
				texlab = {
					build = {
						executable = 'latexmk',
						args = {'-pdflatex', '-interaction=nonstopmode', '-synctex=1', '%f'},
						forwardSearchAfter = false, -- show pdfviewer after build
						onSave = true, -- rebuild automatically after .tex saved
						-- I want to not focus the viewer whenever rebuild. so forwardSearchAfter is false.
						-- '-pv' option open default pdf viewer like acrobat
					},
					forwardSearch = {
						executable = 'SumatraPDF',
						args = {
							'-reuse-instance',
							'%p',
							'-forward-search',
							'%f',
							'%l',
						}
					},
					completion = {
						matcher = 'prefix-ignore-case',
					}
					-- chktex performance is not exact
				}
			},
			single_file_support = true,
		})



		-- ####### autocmd key mapping when LspAttach ######
		-- vim.api.nvim_create_autocmd('LspAttach', {
		-- 	desc = 'lsp keybindings when on_attach',
		-- 	callback = function()
		-- 		local opts = {buffer = true, silent = true, noremap = true}
		-- 		-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)	-- hover current line function
		-- 		vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<cr>', opts)				-- hover current cursor item
		-- 		vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', opts)		-- function / var def
		-- 		vim.keymap.set('n', 'gD', ':lua vim.lsp.buf.type_definition()<cr>', opts)	-- type def
		-- 		vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.reference()<cr>', opts)			-- function / var ref
		-- 		vim.keymap.set('n', 'gs', vim.lsp.buf.code_action)
		-- 	end
		-- })

		-- global mapping for diagnostic
		-- vim.keymap.set('n', 'gk', vim.diagnostic.goto_next) -- show next diagnostic result


		-- set keymaps locally for texlab
		local LaTeXKey = vim.api.nvim_create_augroup('LaTeXKey', {clear = true})
		vim.api.nvim_create_autocmd('LspAttach', {
			group = LaTeXKey,
			callback = function ()
				if vim.b[0].texlab_attach then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf() -- get current buf id
				local clients = vim.lsp.buf_get_clients(bufnr) -- get lsp table which is attached on current buffer
				for _, client in pairs(clients) do --  ipairs is effective when table has key from 1
					if client.name == 'texlab' then
						vim.b[0].texlab_attach = true
					end
				end

				if vim.b[0].texlab_attach then
					vim.keymap.set('n', '<leader>lv', '<Cmd>TexlabForward<CR>', {noremap = true, buffer = 0, desc = 'latex - forward search'})
					vim.keymap.set('n', '<leader>ll', '<Cmd>TexlabBuild<CR>', {noremap = true, buffer = 0, desc = 'latex - Build'})
				end
			end
		})


		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics, {
				virtual_text = false
			}
		)
	end
}
