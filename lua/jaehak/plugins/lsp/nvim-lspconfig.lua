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
			-- root_dir = lsp_util.root_pattern('*.m'),
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
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


		-- ###### 6) python language server configuration ###########
		-- I think ruff's linting seems a bit lacking 
		lspconfig.ruff_lsp.setup({ -- use ruff as python linter
			on_attach = function (client, bufnr)
				-- lsp use ruff to formatter
				client.server_capabilities.documentFormattingProvider = true -- enable vim.lsp.buf.format(), actually true is default
				client.server_capabilities.documentRangeFormattingProvider = true
			end,
			-- cmp_nvim_lsp default_configuration add completionProvider. ruff_lsp don't use completion
			filetype = {'python'},
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
			single_file_support = true,
			init_options = {
				settings = {
					lint = { -- it links with ruff, but lint.args are different with ruff configuration 
						enable = true,
						run = 'onType',
					},
				}
			}
		})

		-- pyright supports some lsp functions, but not enough
		lspconfig.pyright.setup({
			-- pyright doesn't have FormattingProvider
			capabilities = capabilities,
			filetype = {'python'},
			settings = {
				pyright = {
					disableLanguageServices = false, -- use basic function (type completion, signature, reference , symbols)
					disableOrganizeImports = false,
					disableTaggedHints = false, -- use hint diagnostic with tag
				},
				python = {
					analysis = {
						autoImportCompletions = true, -- use auto import
						diagnosticMode = 'openFilesOnly', -- analyze only open files
						ignore = {'*'}, -- paths or files whose diagnostic output should be suppressed
						typeCheckingMode = 'off', -- all type checking rules are disabled (use ruff)
						useLibraryCodeForTypes = true, -- analyze library code to extract type information
					}
				}
			}
		})

		-- pylsp is slow? 
		lspconfig.pylsp.setup({ -- pure pylsp has no ruff configuration, for completion / lsp_signature
			-- pylsp has FormattingProvider, but I don't set the formatter
			on_attach = function (client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			capabilities = capabilities, -- required 
			filetyps = {'python'},
			settings = {
				pylsp = {
					plugins = {
						autopep8            = { enabled = false },
						flake8              = { enabled = false },
						jedi_completion     = { -- support completion
							enabled = false,
							include_params = true, -- required : not default, add () besides of function (little snippet for builtin)
							include_class_objects = false,
							include_function_objects = false, -- add function object to completion separately. make duplicated item
							fuzzy = false,
							eager = false,
						},
						jedi_definition     = { enabled = false },
						jedi_hover          = { enabled = false },
						jedi_references     = { enabled = false },
						jedi_signature_help = { enabled = false }, -- support lsp_signature help
						jedi_symbols        = { enabled = false },
						mccabe              = { enabled = false },
						preload             = { enabled = false },
						pycodestyle         = { enabled = false },
						pyflakes            = { enabled = false },
						pylint              = { enabled = false },
						rope_autoimport     = { enabled = false },
						yapf                = { enabled = false },
					}
				}
			}
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




		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics, {
				virtual_text = false
			}
		)
	end
}
