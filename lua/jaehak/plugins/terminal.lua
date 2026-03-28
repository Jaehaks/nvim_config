return {
{
	"wr9dg17/essential-term.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	keys = {
		{ "<C-r>", "<cmd>EssentialTermToggle<cr>", mode = { "n", "t" } },
		{ "<C-t>",  "<cmd>EssentialTermNew<cr>",    mode = { "t" } },
		{ "<C-x>",  "<cmd>EssentialTermClose<cr>",  mode = { "t" } },
		{ "<C-h>",  "<cmd>EssentialTermPrev<cr>",   mode = { "t" } },
		{ "<C-l>",  "<cmd>EssentialTermNext<cr>",   mode = { "t" } },
	},
	opts = {
		size            = 30,           -- percentage of editor lines/columns used by the terminal
		display_mode    = "horizontal", -- "horizontal" | "vertical" | "float"
		sidebar_width   = 10,           -- width of the session-picker sidebar (horizontal mode)
		border          = "rounded",    -- border style for float mode (see :h nvim_open_win)
		close_on_exit   = true,         -- destroy session when shell exits
		start_in_insert = true,         -- enter insert mode on open/focus
		escape_key      = false,        -- <Esc> key to exit terminal mode and hide the terminal; false to disable
		colors          = {             -- optional terminal window colors
			bg = nil,                   -- hex color string, e.g. "#1e1e2e"; nil uses default bg
			fg = nil,                   -- hex color string; nil uses default fg
		},
	},
	config = function (_, opts)
		-- set shell cmd option by OS
		local shell_cmd
		if vim.g.has_win32 then
			shell_cmd = {vim.o.shell, '/k', require('jaehak.core.paths').shell.aliase}
		else
			shell_cmd = {vim.o.shell}
		end
		opts.shell = shell_cmd

		require('essential-term').setup(opts)

		-- show cursorline in normal mode
		local term_augroup = vim.api.nvim_create_augroup("TerminalCursorLine", { clear = true })
		vim.api.nvim_create_autocmd("TermLeave", {
			group = term_augroup,
			pattern = "term://*",
			callback = function()
				vim.opt_local.cursorline = true
			end,
		})

		vim.api.nvim_create_autocmd("TermEnter", {
			group = term_augroup,
			pattern = "term://*",
			callback = function()
				vim.opt_local.cursorline = false
			end,
		})
	end
}
}
