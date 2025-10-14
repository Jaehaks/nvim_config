-- #############################################################
-- ####### environment variable for lsp
-- #############################################################
local sep = vim.g.has_win32 and ';' or ':'
vim.env.PATH = require('jaehak.core.paths').nvim.mason .. sep .. vim.env.PATH -- call lsp without mason
vim.env.RUFF_CACHE_DIR = require('jaehak.core.paths').lsp.ruff.cache_path --  set ruff cache directory
local pid = {
	pyrefly = {}
}

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
	float = {
		format = function (diag)
			return string.format('%s (%s)', diag.message, diag.source)
		end,
		border = 'rounded',
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
		local root = vim.fs.root(bufnr, {'.git'}) or vim.fn.expand('%:p:h')
		-- root directory must be transferred to callback function to recognize
		cb(root)
	end,
})




-- WARN: it doesn't matter what you set the config name, but it must not contains underscore('_') in the name
-- #############################################################
-- ####### lus-ls config
-- #############################################################
local root_dir_lua = function (bufnr, cb)
	local root = vim.fs.root(bufnr, {
		'luarc.json',
		'.luarc.json',
		'.git'
	}) or vim.fn.expand('%:p:h')
	cb(root)
end
vim.lsp.config('lua_ls', {
	cmd = {'lua-language-server'},
	filetypes = {'lua'},
	root_dir = root_dir_lua,
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
		single_file_support = false,
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
			installPath = require('jaehak.core.paths').lsp.matlab,
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
-- main purpose is fast linting diagnostics
local root_dir_ruff = function (bufnr, cb)
	local root = vim.fs.root(bufnr, {
		'pyproject.toml',
		'ruff.toml',
		'.ruff.toml',
		'.git'
	}) or vim.fn.expand('%:p:h')
	cb(root)
end
vim.lsp.config('ruff', {
	cmd = {'ruff', 'server'},
	filetypes = {'python'},
	root_dir = root_dir_ruff,
	on_attach = function (client, _)
		-- lsp use ruff to formatter
		client.server_capabilities.documentFormattingProvider = false      -- enable vim.lsp.buf.format()
		client.server_capabilities.documentRangeFormattingProvider = false -- formatting will be used by confirm.nvim
		client.server_capabilities.hoverProvider = false                   -- use basedpyrigt
	end,
	init_options = {
		settings = {
			configuration = require('jaehak.core.paths').lsp.ruff.config_path,
			logFile = require('jaehak.core.paths').lsp.ruff.log_path,
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
	single_file_support = false,
})


-- #############################################################
-- ####### basedpyright
-- #############################################################
-- main purpose is exact type checking diagnostics
-- It has very slow lsp completion to use
local root_dir_basedpyright = function (bufnr, cb)
	local root = vim.fs.root(bufnr, {
		'pyproject.toml',
		'pyrightconfig.json',
		'.git'
	}) or vim.fn.expand('%:p:h')
	cb(root)
end
vim.lsp.config('basedpyright', {
	cmd = {'basedpyright-langserver', '--stdio'},
	filetypes = {'python'},
	root_dir = root_dir_basedpyright,
	on_attach = function (client, _)
		client.server_capabilities.completionProvider        = false -- use pyrefly for fast response
		client.server_capabilities.definitionProvider        = false -- use pyrefly for fast response
		client.server_capabilities.documentHighlightProvider = false -- use pyrefly for fast response
		client.server_capabilities.renameProvider            = false -- use pyrefly as I think it is stable
		client.server_capabilities.semanticTokensProvider    = false -- use pyrefly it is more rich
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
})

-- #############################################################
-- ####### pyrefly
-- #############################################################
-- main purpose is fast completion/semanticTokens
-- the alternative of it is ty, but it is experimental yet
local root_dir_pyrefly = function (bufnr, cb)
	local root = vim.fs.root(bufnr, {
		'pyproject.toml',
		'pyrefly.roml',
		'.git'
	}) or vim.fn.expand('%:p:h')
	cb(root)
end
vim.lsp.config('pyrefly', {
	cmd = {'pyrefly', 'lsp'},
	filetypes = {'python'},
	root_dir = root_dir_pyrefly,
	on_attach = function (client, _)
		client.server_capabilities.codeActionProvider     = false -- basedpyright has more kinds
		client.server_capabilities.documentSymbolProvider = false -- basedpyright has more kinds
		client.server_capabilities.hoverProvider          = false -- basedpyright has more kinds
		client.server_capabilities.inlayHintProvider      = false -- basedpyright has more kinds
		client.server_capabilities.referenceProvider      = false -- basedpyright has more kinds
		client.server_capabilities.signatureHelpProvider  = false -- basedpyright has more kinds

		if vim.g.has_win32 then
			table.insert(pid.pyrefly, require('jaehak.core.utils').GetProcessId('pyrefly.exe'))
		end
	end,
	on_exit = function ()
		if vim.g.has_win32 then
			for id in ipairs(pid.pyrefly) do
				require('jaehak.core.utils').Taskkill(id)
			end
		end
	end,
	settings = {
	},
})



-- #############################################################
-- ####### texlab
-- #############################################################
-- it supports lsp functions for latex
-- 1) install miktex from https://miktex.org/download not scoop
-- 2) set <miktex_install_path>/miktex/bin/x64 to PATH to make latexmk executable
-- 3) j
--
-- comments:
-- texlab supports build / forward search / reverse search and the building process is notified with fidget.nvim
-- but some operation is weak
-- %l cannot be recognized (bug), it prevent forward search
-- %f, %l must be independent item in table. I want to write -outdir depends on filename, it cannot use
-- OnSave feature is good, but I want to turn on/off like vimtex
-- sioyek main branch cannot recognize toggle_synctex at startup
vim.lsp.config('texlab', {
	cmd = {'texlab'},
	filetypes = {'tex', 'plaintex', 'bib'},
	settings = { -- see https://github.com/latex-lsp/texlab/wiki/Configuration
		texlab = {
			build = {
				executable = 'latexmk',
				args = {
					'-interaction=nonstopmode', -- continuous mode compilation
					'%f',                       -- current file
				},
				onSave = false,                 -- build on save (it works when :w but not autocmd save)
				forwardSearchAfter = false,     -- perform forward search after build
			},
			forwardSearch = {
				executable = 'sioyek',
				args = {
					"--reuse-window",
					"--inverse-search",
					"texlab inverse-search -i \"%%1\" -l %%2",
					"--forward-search-file",
					"%f",
					"--forward-search-line",
					"%l",
					"%p",
				},
			},
			latexFormatter = 'latexindent',
			latexindent = {
				modifyLineBreaks = false,
			}
		},
	},
})


-- #############################################################
-- ####### json-lsp config
-- #############################################################
vim.lsp.config('json_lsp', {
	cmd = {'vscode-json-language-server', '--stdio'},
	filetypes = {'json', 'jsonc'},
	init_options = {
		provideFormatter = true,
	},
})


-- #############################################################
-- ####### marksman config
-- #############################################################
-- markdown-oxide : it works weird. some strings are removed when completion for link is inserted
-- 					it doesn't support go to definition
local root_dir_marksman = function (bufnr, cb)
	local root = vim.fs.root(bufnr, {
		'.marksman.toml',
		'.git'
	}) or vim.fn.expand('%:p:h')
	cb(root)
end
vim.lsp.config('marksman', {
	on_attach = function ()
		-- TODO: 1) make header / file list to add link in projects
		-- TODO: 2) implement obsidian's image (ClipboardPaste)

		-- gd : use lspsaga's peek_definition()
		-- ga : code action to make toc
		-- K : use lspsaga's hover
		-- <leader>fs : lsp_symbol, but it will show header lists
		-- 		-- vim.keymap.set('n', '<leader>mw', '<Cmd>Obsidian Workspace<CR>',       {noremap = true, desc = '(Obsidian)switch another workspace'})
		-- 		-- vim.keymap.set('n', '<leader>ms', '<Cmd>Obsidian quick_switch<CR>',    {noremap = true, desc = '(Obsidian)Switch another file'})
		-- 		-- vim.keymap.set('n', '<leader>mn', '<Cmd>Obsidian new<CR>',             {noremap = true, desc = '(Obsidian)Make new obsidian note'})
		-- 		-- vim.keymap.set('n', '<leader>mo', '<Cmd>Obsidian open<CR>',            {noremap = true, desc = '(Obsidian)Open a note in obsidian app'})
		-- 		-- vim.keymap.set('n', '<C-c>',      '<Cmd>Obsidian toggle_checkbox<CR>', {noremap = true, desc = '(Obsidian)Toggle checkbox'})
		--
	end,
	cmd = {'marksman', 'server'},
	filetypes = {'markdown'},
	root_dir = root_dir_marksman,
})


-- #############################################################
-- ####### clangd config
-- #############################################################
local root_dir_clangd = function (bufnr, cb)
	local root = vim.fs.root(bufnr, {
		'.clangd',
		'.clang-tidy',
		'.clang-format',
		'.compile_commands.json',
		'.compile_flags.txt',
		'.configure.ac',
		'.git'
	}) or vim.fn.expand('%:p:h')
	cb(root)
end
---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

---@type vim.lsp.Config
vim.lsp.config('clangd', {
	cmd = {'clangd'},
	filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
	root_dir = root_dir_clangd,
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-8', 'utf-16' },
	},
	---@param init_result ClangdInitializeResult
	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end
	end,
	-- on_attach = function(client, bufnr)
	-- 	-- check : https://github.com/neovim/nvim-lspconfig/blob/623bcf08d5f9ff4ee3ce2686fa1f1947a045b1a5/lsp/clangd.lua#L65
	--
	-- 	vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
	-- 		switch_source_header(bufnr, client)
	-- 	end, { desc = 'Switch between source/header' })
	--
	-- 	vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
	-- 		symbol_info(bufnr, client)
	-- 	end, { desc = 'Show symbol info' })
	-- end,
})

-- #############################################################
-- ####### lsp enable
-- #############################################################
vim.lsp.enable({
	'lua_ls',
	'matlab-ls',
	-- 'harper-ls',
	'ruff',
	'pyrefly',
	'basedpyright',
	'texlab',
	'json_lsp',
	'marksman',
	'clangd',
})


-- #############################################################
-- ####### Tips
-- #############################################################
--
-- vim.lsp.get_clients() : get active client list table
-- vim.lsp.get_clients()[1].server_info : server name & version
-- vim.lsp.get_clients()[1]._log_prefix : client name like LSP[texlab]
-- vim.lsp.get_clients()[1].server_capabilities : support server capabilities
-- vim.lsp.get_clients()[1].capabilities : what?
