return {
{
	"stevearc/conform.nvim",
	enabled = true,
	ft = "*",
	config = function()
		-- configuration
		local conform = require("conform")
		local ruff_config_path = vim.fn.stdpath('config') .. '/queries/ruff/ruff.toml'
		if vim.g.has_win32 == 1 then
			ruff_config_path = ruff_config_path:gsub('/', '\\')
		end
		conform.setup({
			-- set formatter configuration
			formatters = {
				stylua = {

				},
				ruff_format = {
					command = 'ruff',
					args = {
						'format',
						'--config=' .. ruff_config_path,
						'--force-exclude',
						'--stdin-filename',
						'$FILENAME',
						'-'
					},
					stdin = true,
				}
			},
			-- set formatter to filetype
			formatters_by_ft = {
				lua = { "stylua"},
				tex = { "latexindent" },
				python = { "ruff_format" },
				-- ["*"] = { "codespell" },       -- on all filetypes
				["_"] = { "trim_whitespace" }, -- on filetypes that  don't have other formatter, it needs awk.
			},
			format_on_save = nil,
			format_after_save = nil,
		})

		-- formatter keymaps
		vim.keymap.set({ "n", "v" }, "<leader>wf", function()
			conform.format({
				lsp_fallback = true, -- use LSP formatting if no formatters
				async = true,        -- formatting asynchronously
			}, function() print("Formatting completed!") end)
		end, { desc = "formatting with all" })

		vim.keymap.set({ "n", "v" }, "<leader>ww", function()
			conform.format({
				lsp_fallback = false,
				async = true,
				formatters = {'trim_whitespace'}
			}, function() print("Formatting completed!") end)
		end, { desc = "formatting with trim_whitespace only" })
	end,
},
{
	'nmac427/guess-indent.nvim',
	config = function()
		require('guess-indent').setup {
			silent = true, -- don't notify about guess operation
			auto_cmd = true,  -- Set to false to disable automatic execution
			override_editorconfig = false, -- Set to true to override settings set by .editorconfig
			filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
				"yazi",
				'Outline',
				"NeogitCommitMessage",
				"markdown"
			},
			buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
				"help",
				"nofile",
				"terminal",
				"prompt",
			},
			on_tab_options = { -- A table of vim options when tabs are detected
				["expandtab"] = false,
			},
			on_space_options = { -- A table of vim options when spaces are detected
				["expandtab"] = false,
				["tabstop"] = "detected", -- If the option value is 'detected', The value is set to the automatically detected indent size.
				["softtabstop"] = "detected",
				["shiftwidth"] = "detected",
			},
		}
	end,
}
}
-- sbdchd/neoformat : format runner, no configuration required because it supports already.
-- 					  Not support async / I think confirm.nvim makes it easier to configure formatter by filetype
-- conform.nvim :
-- 		sometimes, formatting in visual mode doesn't work. and visual formatting does not work properly
-- 		I failed to make apply custom formatter for matlab using matlab-formatter-vscode ...
-- 		codespell doesn't work?
-- 'nmac427/guess-indent.nvim' : guess tab setting from buffer.
-- 								 it would be helpful when I work for PR because most of people use 2 tabs
