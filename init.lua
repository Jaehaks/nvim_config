if vim.g.vscode then		-- vscode config is separated
	require('jaehak.core.keymaps')
	require('jaehak.lazy_manager')
else
	-- require("jaehak.core")
	require("jaehak.core.autocmds")
	require("jaehak.core.keymaps")
	require("jaehak.core.options")
	-- require("jaehak.core.paths")
	require("jaehak.core.utils")
	require("jaehak.core.lsp")
	require("jaehak.lazy_manager")
end

