local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.g.has_win32 == 1 then
	lazypath = lazypath:gsub('/', '\\')
end

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-------------------------------------------------------------
-- lazy.vim plugin manager settings,    plugin list
-------------------------------------------------------------
if vim.g.vscode == nil then
	require('lazy').setup({
		{import = 'jaehak.plugins'},
		{import = 'jaehak.plugins.lsp'}}, {
			change_detection = {
				--		enabled = false,
				notify = false,
			},
			rocks = { -- disable lazy.nvim's luarocks supports for fugit2
				enabled = false,
			}
		})
else		-- for vscode
	require('lazy').setup({
		{import = 'jaehak.plugins.flash'},
		}, {
			change_detection = {
				--		enabled = false,
				notify = false,
			},
		})
end
