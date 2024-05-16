return {
	{
		"stevearc/conform.nvim",
		enabled = true,
		ft = "*",
		config = function()
			-- configuration
			local conform = require("conform")
			conform.setup({
				-- set formatter configuration
				formatters = {
					stylua = {

					}
				},
				-- set formatter to filetype
				formatters_by_ft = {
					lua = { "stylua"},
					tex = { "latexindent" },
					python = { "ruff" },
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
}
-- sbdchd/neoformat : format runner, no configuration required because it supports already.
-- 					  Not support async / I think confirm.nvim makes it easier to configure formatter by filetype
-- conform.nvim :
-- 		sometimes, formatting in visual mode doesn't work. and visual formatting does not work properly
-- 		I failed to make apply custom formatter for matlab using matlab-formatter-vscode ...
-- 		codespell doesn't work?
