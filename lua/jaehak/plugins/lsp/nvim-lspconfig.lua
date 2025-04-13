local paths = require('jaehak.core.paths')
local sign_priority = {
	rank1 = 20,
	rank2 = 10, -- default of lsp
	rank3 = 3,
	-- sign of gitsign.nvim is 10
}

-- TODO: the diagnostics behavior is weird when I set this.  it will be corrected
-- local create_custom_handler = function (priority)
-- 	return function (err, result, ctx, config)
-- 		if err then
-- 			vim.notify('err : ' .. err.message, vim.log.levels.ERROR)
-- 			return
-- 		end
--
-- 		-- override to default diagnostic config
-- 		local default_config = vim.diagnostic.config()
-- 		config = vim.tbl_deep_extend('force', default_config or {}, config or {})
-- 		config.signs = config.signs or {}
-- 		config.signs.priority = priority
--
-- 		-- set missed field like lnum, col in diagnostics to use vim.diagnostics.set()
-- 		local diagnostics = {}
-- 		for _, diagnostic in ipairs(result.diagnostics or {}) do
-- 			table.insert(diagnostics, {
-- 				lnum     = diagnostic.range.start.line,
-- 				col      = diagnostic.range.start.character,
-- 				end_lnum = diagnostic.range["end"].line or nil,
-- 				end_col  = diagnostic.range["end"].character or nil,
-- 				message  = diagnostic.message,
-- 				severity = diagnostic.severity,
-- 				source   = diagnostic.source,
-- 			})
-- 		end
--
-- 		-- apply configuration
-- 		vim.diagnostic.set(ctx.client_id, ctx.bufnr or vim.api.nvim_get_current_buf(), diagnostics, config)
-- 	end
-- end

return {
	{
		-- replacement of neodev, for neovim config
		-- but it doesn't supports highlights for vim global variable
		'folke/lazydev.nvim',
		enabled = true,
		ft = 'lua',
		opts = {
			library = {
				-- default : vim global variable's auto completion excepts vim.uv
				{ path = '${3rd}\\luv\\library', words = {'vim%.uv'} }, -- for vim.uv auto completion
				-- `Snacks` library useful when I configure this plugin, it can check undefined variable
			},
			-- -- load lazydev always even though there are .luarc.json
			-- enabled = function (root_dir)
			-- 	return vim.bo.filetype == 'lua'
			-- end
		}
	},
	{
		-- nvim-lspconfig must be loaded after than mason. If not, spawning server warning fired
		'neovim/nvim-lspconfig',
		enabled = false,
		event = 'BufReadPre',
		dependencies = {
			'williamboman/mason.nvim',	-- to recognize language server ahead of lspconfig
		},
		init = function ()
			vim.env.RUFF_CACHE_DIR = paths.lsp.ruff.cache_path --  set ruff cache directory
		end,
		config = function()
			-- configuration lspconfig using opt field of lazy.nvim doesn't work.
			-- I don't know what is the reason
			-- neodev must call setup in lspconfig's config field


			local lspconfig = require('lspconfig')
			local lsp_util = require('lspconfig.util')
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			-- ####### set diagnostics as numhl to distinguish with gitsign
			-- global lsp diagnostic configuration at neovim v0.11
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = '',
						[vim.diagnostic.severity.WARN]  = '',
						[vim.diagnostic.severity.INFO]  = '',
						[vim.diagnostic.severity.HINT]  = '',
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = 'DiagnosticERRORReverse',
						[vim.diagnostic.severity.WARN]  = 'DiagnosticWARNReverse',
						[vim.diagnostic.severity.INFO]  = 'DiagnosticINFOReverse',
						[vim.diagnostic.severity.HINT]  = 'DiagnosticHINTReverse',
					}
				},
				underline     = false, -- disable underline representation
				severity_sort = true,  -- enable sort by severity when it collide in one line
				virtual_text  = false  -- default is false in neovim v0.11
			})


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
							globals = {'vim', 'Snacks'},	-- recognize 'vim' global to language server
							undefined_global = false,
						},
						workspace = {
							ignoreDir = {'.git'},
							checkThirdParty = false,
							library = {
								-- vim.env.VIMRUNTIME,
								vim.api.nvim_get_runtime_file('lua',true),

								-- ## below two directories make lsp loading too slow
								-- I think stdpath('data') load all plugins even though it has "enabled = false"
								--							vim.fn.stdpath('config'),
								--							vim.fn.stdpath('data'),
							}
						}
					}
				},
				capabilities = capabilities,
				-- handlers = {
				-- 	['textDocument/publishDiagnostics'] = create_custom_handler(sign_priority.rank1)
				-- }
			})

			-- ####### 2) matlab language server configuration #########
			lspconfig.matlab_ls.setup({
				on_attach = function (client, bufnr)
					-- client.server_capabilities.signatureHelpProvider = false -- signature help by matlab lsp is poor
				end,
				cmd = {'matlab-language-server', '--stdio'},
				filetypes = {'matlab'},
				root_dir = function (fname)
					return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
				end,
				settings = {
					matlab = {
						indexWorkspace = true,
						installPath = paths.lsp.matlab,
						matlabConnectionTiming = 'onStart',
						telemetry = false, -- don't report about any problem
					},
				},
				single_file_support = false, -- if enabled, lsp(matlab.exe) attaches per file, too heavy
				-- handlers = {
				-- 	['textDocument/publishDiagnostics'] = create_custom_handler(sign_priority.rank1)
				-- }

			})

			-- grammar-guard.nvim : deprecated
			-- prosesitter : deprecated
			-- ltex : too heavy to load. its speed is too slow

			-- ####### 6) harper_ls language server configuration #########
			-- more faster than ltex
			-- lspconfig.harper_ls.setup({
			-- 	filetypes = {'gitcommit', 'markdown', 'text', 'NeogitStatus', 'lua'},
			-- 	settings = {
			-- 		['harper-ls'] = {
			-- 			linters = {
			-- 				spell_check                  = true,
			-- 				spelled_numbers              = false,
			-- 				an_a                         = true,
			-- 				sentence_capitalization      = false,
			-- 				unclosed_quotes              = true,
			-- 				wrong_quotes                 = true,
			-- 				long_sentences               = false,
			-- 				repeated_words               = false,
			-- 				spaces                       = true,
			-- 				matcher                      = true,
			-- 				correct_number_suffix        = false,
			-- 				number_suffix_capitalization = false,
			-- 				multiple_sequential_pronouns = true,
			-- 				linking_verbs                = true,
			-- 				avoid_curses                 = false,
			-- 				terminating_conjuctions      = true,
			-- 			},
			-- 			diagnosticSeverity = 'hint', -- show the spell check as hint
			-- 			codeActions = {
			-- 				forceStable = true
			-- 			}
			-- 		}
			-- 	},
			-- 	handlers = {
			-- 		['textDocument/publishDiagnostics'] = create_custom_handler(sign_priority.rank3)
			-- 	}
			--
			-- })


			-- ###### 6) python language server configuration ###########
			-- a) ruff : use code_action(but cannot all fix) / use Formatting / fast type check inherited
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
			-- (241117) : ruff_lsp is deprecated
			--
			lspconfig.ruff.setup({ -- use ruff as python linter
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
				single_file_support = true,
				init_options = {
					settings = {
						configuration = paths.lsp.ruff.config_path,
						logFile = paths.lsp.ruff.log_path,
						logLevel = 'warn',
						organizeImports = true, -- use code action for organizeImports
						showSyntaxErrors = true, -- show syntax error diagnostics
						codeAction = {
							disableRuleComment = { enable = false }, -- show code action about rule disabling
							fixViolation = { enable = false }, -- show code action for autofix violation
						},
						format = {			-- use conform.nvim
							preview = false,
						},
						lint = {            -- it links with ruff, but lint.args are different with ruff configuration
							enable = true,
						},
					}
				},
				-- handlers = { -- it seems not work right now
				-- 	['textDocument/publishDiagnostics'] = create_custom_handler(sign_priority.rank1)
				-- }
			})

			-- It seems that basedpyright give more feature than pyright and pylsp (lsp signature, completion)
			--
			lspconfig.basedpyright.setup({ -- use pyright as type checker , for definition/hover
				on_attach = function (client, bufnr)
					-- pyright doesn't have FormattingProvider
					-- client.server_capabilities.hoverProvider = true          -- pylsp gives more params explanation. pyright gives more type explanation
					-- client.server_capabilities.completionProvider = false    -- use pylsp instead
					-- client.server_capabilities.signatureHelpProvider = false -- use pylsp instead
				end,
				capabilities = capabilities,
				filetype = {'python'},
				root_dir = function (fname)
					return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
				end,
				settings = { -- see https://docs.basedpyright.com/latest/configuration/language-server-settings/
					basedpyright = {
						disableOrganizeImports = true, -- use ruff instead of it
						analysis = {
							autoImportCompletions = true,
							autoSearchPaths = true, -- auto serach command paths like 'src'
							diagnosticMode = 'openFilesOnly',
							useLibraryCodeForTypes = true,
						}
					},
				},
				-- handlers = {
				-- 	['textDocument/publishDiagnostics'] = create_custom_handler(sign_priority.rank1)
				-- }
			})
		end
	},
}
