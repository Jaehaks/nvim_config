if vim.g.vscode then		-- vscode config is separated
	require('jaehak.core.keymaps')
	require('jaehak.lazy_manager')
else
	require("jaehak.core")
	require("jaehak.lazy_manager")
end

