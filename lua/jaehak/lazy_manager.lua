local lazypath = vim.fn.stdpath("data") .. "\\lazy\\lazy.nvim"
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
require('lazy').setup({
	{import = 'jaehak.plugins'},
	{import = 'jaehak.plugins.lsp'}}, {
	change_detection = {
--		enabled = false,
		notify = false,
	},
})


