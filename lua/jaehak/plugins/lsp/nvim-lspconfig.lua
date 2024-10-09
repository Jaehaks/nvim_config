local paths = require('jaehak.core.paths')
return {
	'neovim/nvim-lspconfig',
	-- lazy = true,		-- nvim-lspconfig must be loaded after than mason. If not, spawning server warning fired
	dependencies = {
		{
			'folke/neodev.nvim',
			ft = {'lua'}
		},
		-- {
		-- 	'folke/lazydev.nvim', -- instead of neodev
		-- 	ft = 'lua',
		-- 	config = function ()
		-- 		require('lazydev').setup({
		-- 			library = {
		-- 				-- { path = 'luvit-meta/library', words = {'vim%.uv'}}
		-- 			},
		-- 			enabled = function(root_dir)
		-- 				return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
		-- 			end
		-- 		})
		-- 	end
		-- },
		-- {
		-- 	'Bilal2453/luvit-meta', -- for lazydev, vim.uv library
		-- 	lazy = true,
		-- },
		'hrsh7th/cmp-nvim-lsp',
		'williamboman/mason.nvim',	-- to recognize language server ahead of lspconfig
	},
	init = function ()
		vim.env.RUFF_CACHE_DIR = paths.nvim.ruff_cache_path --  set ruff cache directory
	end,
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
						showWord = 'Disable' -- disable word suggestion of lsp
					},
					diagnostics = {
						disable = {
							'missing-parameter',	-- disable diagnostics about whether all fields are filled
							'missing-fields',
							'unused-function',
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
		local matlab_path = vim.fs.dirname(vim.fn.systemlist('where matlab')[1]):match('(.*[/\\])')
		if vim.g.has_win32 == 1 then
			matlab_path:gsub('/','\\')
		end
		lspconfig.matlab_ls.setup({
			on_attach = function (client, bufnr)
				client.server_capabilities.signatureHelpProvider = false -- signature help by matlab lsp is poor
			end,
			cmd = {'matlab-language-server', '--stdio'},
			filetypes = {'matlab'},
			-- root_dir = lsp_util.root_pattern('*.m'),
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
			settings = {
				matlab = {
					indexWorkspace = true,
					installPath = matlab_path,
					matlabConnectionTiming = 'onStart',
					telemetry = true,
				},
			},
			single_file_support = false, -- if enabled, lsp(matlab.exe) attaches per file, too heavy
		})

		-- grammar-guard.nvim : deprecated
		-- prosesitter : deprecated

		-- ####### 6) harper_ls language server configuration #########
		-- more faster than ltex
		lspconfig.harper_ls.setup({
			filetypes = {'gitcommit', 'markdown', 'text', 'NeogitCommitMessage', 'lua'},
			settings = {
				['harper-ls'] = {
					linters = {
						spell_check                  = true,
						spelled_numbers              = false,
						an_a                         = true,
						sentence_capitalization      = false,
						unclosed_quotes              = true,
						wrong_quotes                 = true,
						long_sentences               = false,
						repeated_words               = false,
						spaces                       = true,
						matcher                      = true,
						correct_number_suffix        = false,
						number_suffix_capitalization = false,
						multiple_sequential_pronouns = true,
					},
					diagnosticSeverity = 'hint', -- show the spell check as hint
					codeActions = {
						forceStable = true
					}
				}
			}
		})


		-- ###### 6) python language server configuration ###########
		-- a) ruff_lsp : use code_action(but cannot all fix) / use Formatting / fast type check inherited
		-- b) pyright : no code_action / no Formatting / fast type check inherited
		-- c) pylsp : no code action / use Formatting / slow type check disinherited
		-- flake8 is also fast, but I found that pyright / ruff are faster a more little bit
		-- 		but not big differences, I understand that type checking of pyright is more accurate than ruff/flake8
		-- 		pyright has more accuracy about unused variable, linter's error is shadowed by other error when it detects multiple error
		-- 		organizeImports is applied to both pyright and ruff / buf ruff has code action to this
		-- 		linter is not type checker... it helps code convention as formatting rule, and better style of code
		--      it detects some trivial error like undefined , but it cannot detect type checking error
		--      On the other hand, pyright does not support linting(better style checker)
		--      but for trivial error, ruff / flake8 / pyright detect in the same time

		lspconfig.ruff_lsp.setup({ -- use ruff as python linter
			on_attach = function (client, bufnr)
				-- lsp use ruff to formatter
				client.server_capabilities.documentFormattingProvider = false      -- enable vim.lsp.buf.format()
				client.server_capabilities.documentRangeFormattingProvider = false -- formatting will be used by confirm.nvim
				client.server_capabilities.hoverProvider = false                   -- use pylsp
			end,
			-- cmp_nvim_lsp default_configuration add completionProvider. ruff_lsp don't use completion
			filetype = {'python'},
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
			single_file_support = false,
			init_options = {
				settings = {
					logLevel = 'error',
					organizeImports = true, -- use code action for organizeImports
					codeAction = {
						disableRuleComment = { enable = false }, -- show options about rule disabling
					},
					format = false,     -- use conform.nvim
					lint = {            -- it links with ruff, but lint.args are different with ruff configuration
						enable = true,
						run = 'onType', -- ruff every keystroke
						args = {        -- pass to ruff check (--config = *.toml)
							'--config=' .. paths.nvim.ruff_config_path,
						},
					},
				}
			}
		})

		-- pyright supports some lsp functions, but not enough
		lspconfig.pyright.setup({ -- use pyright as type checker , for definition/hover
			on_attach = function (client, bufnr)
				-- pyright doesn't have FormattingProvider
				client.server_capabilities.hoverProvider = true          -- pylsp gives more params explanation. pyright gives more type explanation
				client.server_capabilities.completionProvider = false    -- use pylsp instead
				client.server_capabilities.signatureHelpProvider = false -- use pylsp instead
			end,
			capabilities = capabilities,
			filetype = {'python'},
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
			settings = {
				pyright = {
					disableLanguageServices = false, -- disable all lsp feature except of hover
					disableOrganizeImports  = true,  -- use ruff instead of it
					disableTaggedHints      = false, -- hint for unused variable, not supports from other lsp
				},
				python = {
					analysis = {
						autoImportCompletions  = false,           -- use auto import
						diagnosticMode         = 'openFilesOnly', -- analyze only open files
						typeCheckingMode       = 'standard',      -- all type checking rules are disabled (use ruff)
						useLibraryCodeForTypes = true,            -- analyze library code to extract type information
					}
				}
			}
		})

		-- pylsp is slow?
		lspconfig.pylsp.setup({ -- for completion / hover / lsp_signature, pure pylsp has no ruff configuration,
			-- pylsp has FormattingProvider, but I don't set the formatter
			on_attach = function (client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
				client.server_capabilities.documentHighlightProvider = false
			end,
			capabilities = capabilities, -- required
			filetyps = {'python'},
			root_dir = function (fname)
				return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
			end,
			settings = {
				pylsp = {
					plugins = {
						autopep8            = { enabled = false },
						flake8              = { enabled = false }, -- fast, diagnostics for linting and formatting
						jedi_completion     = { -- support completion
							enabled = true,
							include_params = true, -- required : not default, add () besides of function (little snippet for builtin)
							include_class_objects = false,
							include_function_objects = false, -- add function object to completion separately. make duplicated item
							fuzzy = false,
							eager = false,
						},
						jedi_definition     = { enabled = false }, -- same with pyright
						jedi_hover          = { enabled = true }, -- better than pyright. it supports explanation
						jedi_references     = { enabled = false },
						jedi_signature_help = { enabled = true }, -- support lsp_signature help, more detail than pyright
						jedi_symbols        = { enabled = false },
						mccabe              = { enabled = false },
						preload             = { enabled = false },
						pycodestyle         = { enabled = false },
						pyflakes            = { enabled = false },
						pylint              = { enabled = false }, -- very slow loading to lint
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
