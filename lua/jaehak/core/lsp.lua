local paths = require('jaehak.core.paths')

-- #############################################################
-- ####### environment variable for lsp
-- #############################################################
local sep = vim.g.has_win32 and ';' or ':'
vim.env.PATH = paths.nvim.mason .. sep .. vim.env.PATH -- call lsp without mason
vim.env.RUFF_CACHE_DIR = paths.lsp.ruff.cache_path --  set ruff cache directory

-- #############################################################
-- ####### set diagnostics as numhl to distinguish with gitsign
-- #############################################################
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


-- #############################################################
-- ####### common lsp configuration
-- #############################################################
-- vim.lsp.config is extension of vim.lsp.ClientConfig
-- but root_dir must be set by independent lsp server
vim.lsp.config('*', {
	root_dir = function (bufnr, cb)
		local root = vim.fs.root(bufnr, {'.git', 'luarc.json', '.luarc.json'}) or vim.fn.getcwd()
		-- root directory must be transferred to callback function to recognize
		cb(root)
	end,
})




-- WARN: it doesn't matter what you set the config name, but it must not contains underscore('_') in the name
-- #############################################################
-- ####### lus-ls config
-- #############################################################
vim.lsp.config('lua_ls', {
	cmd = {'lua-language-server'},
	filetypes = {'lua'},
	settings = {
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
					-- vim.api.nvim_get_runtime_file('lua',true),

					-- `lazydev` imports vim.env.VIMRUNTIME automatically in `library` field.
					-- so you don't need to set in `library` field with `lazydev`
					-- it loads libraries which is what you declared in lua file using `require()` function when it detects.
					-- it is very convenient to write neovim lua plugins.
					-- plus, If you add source 'lazydev' in nvim-cmp, it suggests the installed plugin names in `require()`
				}
			},
		},
		single_file_support = true,
	},
})

-- #############################################################
-- ####### matlab-ls config
-- #############################################################
vim.lsp.config('matlab-ls', {
	cmd = {'matlab-language-server', '--stdio'},
	filetypes = {'matlab'},
	settings = {
		matlab = {
			indexWorkspace = true,
			installPath = paths.lsp.matlab,
			matlabConnectionTiming = 'onStart',
			telemetry = false, -- don't report about any problem
		},
	},
	single_file_support = false, -- if enabled, lsp(matlab.exe) attaches per file, too heavy
})



-- grammar-guard.nvim : deprecated
-- prosesitter : deprecated
-- ltex : too heavy to load. its speed is too slow
-- #############################################################
-- ####### harper_ls language server configuration (more faster than ltex)
-- #############################################################
vim.lsp.config('harper-ls', {
	cmd = {'harper-ls', '--stdio'},
	filetypes = {'gitcommit', 'markdown', 'text', 'NeogitStatus', 'lua'},
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
				linking_verbs                = true,
				avoid_curses                 = false,
				terminating_conjuctions      = true,
			},
			diagnosticSeverity = 'hint', -- show the spell check as hint
			codeActions = {
				forceStable = true
			}
		}
	},
	single_file_support = false,
})



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
-- cmp_nvim_lsp default_configuration add completionProvider. ruff_lsp don't use completion
-- #############################################################
-- ####### ruff : linter
-- #############################################################
vim.lsp.config('ruff', {
	cmd = {'ruff', 'server'},
	filetypes = {'python'},
	on_attach = function (client, bufnr)
		-- lsp use ruff to formatter
		client.server_capabilities.documentFormattingProvider = false      -- enable vim.lsp.buf.format()
		client.server_capabilities.documentRangeFormattingProvider = false -- formatting will be used by confirm.nvim
		client.server_capabilities.hoverProvider = false                   -- use pylsp
	end,
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
		},
	},
	single_file_support = true,
})


-- #############################################################
-- ####### basedpyright
-- #############################################################
-- it supports lsp functions like lspsaga
vim.lsp.config('basedpyright', {
	cmd = {'basedpyright-langserver', '--stdio'},
	filetypes = {'python'},
	on_attach = function (client, bufnr)
		-- pyright doesn't have FormattingProvider
		-- client.server_capabilities.hoverProvider = true          -- pylsp gives more params explanation. pyright gives more type explanation
		-- client.server_capabilities.completionProvider = false    -- use pylsp instead
		-- client.server_capabilities.signatureHelpProvider = false -- use pylsp instead
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
	single_file_support = true,
})





-- #############################################################
-- ####### lsp enable
-- #############################################################
vim.lsp.enable({
	'lua_ls',
	'matlab-ls',
	-- 'harper-ls',
	'ruff',
	'basedpyright',

})


