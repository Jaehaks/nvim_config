-- common definition for user
vim.g.has_win32 = vim.fn.has('win32') == 1 and true or false

if vim.g.vscode then		-- vscode config is separated
	require('jaehak.core.keymaps')
	require('jaehak.lazy_manager')
else
	-- require("jaehak.core")
	require("jaehak.core.keymaps")
	require("jaehak.core.options")
	require("jaehak.core.filetypes")
	if vim.g.has_win32 then
		require("jaehak.core.ime")
	end
	require("jaehak.core.autocmds")
	require("jaehak.core.utils")
	require("jaehak.core.usercmds")
	require("jaehak.lazy_manager")
	require("jaehak.core.lsp")
end

