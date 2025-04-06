local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.g.has_win32 == 1 then
	lazypath = lazypath:gsub('/', '\\')
end

if not vim.uv.fs_stat(lazypath) then
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
		{import = 'jaehak.plugins.auxiliary'     	  , enabled = true},
		{import = 'jaehak.plugins.buffer_manager'     , enabled = false},
		{import = 'jaehak.plugins.colorscheme'        , enabled = true},
		{import = 'jaehak.plugins.snacks'             , enabled = true},
		{import = 'jaehak.plugins.dashboard'          , enabled = true},
		{import = 'jaehak.plugins.yazi'               , enabled = true},
		{import = 'jaehak.plugins.lsp.comment'        , enabled = true},
		{import = 'jaehak.plugins.lsp.formatter'      , enabled = true},
		{import = 'jaehak.plugins.lsp.vim-easy-align' , enabled = true},
		{import = 'jaehak.plugins.colorcode'          , enabled = true},
		{import = 'jaehak.plugins.diffview'           , enabled = true},
		{import = 'jaehak.plugins.fidget'             , enabled = true},
		{import = 'jaehak.plugins.flash'              , enabled = true},
		{import = 'jaehak.plugins.gitsigns'           , enabled = true},
		{import = 'jaehak.plugins.grapple'            , enabled = true},
		{import = 'jaehak.plugins.grug-far'           , enabled = true},
		{import = 'jaehak.plugins.hlchunk'            , enabled = true},
		{import = 'jaehak.plugins.marks'              , enabled = true},
		{import = 'jaehak.plugins.neogit'             , enabled = true},
		{import = 'jaehak.plugins.neominimap'         , enabled = true},
		{import = 'jaehak.plugins.nvim-context-vt'    , enabled = true},
		{import = 'jaehak.plugins.nvim-hlslens'       , enabled = true},
		{import = 'jaehak.plugins.obsidian'           , enabled = true},
		{import = 'jaehak.plugins.spelunk'            , enabled = false},
		{import = 'jaehak.plugins.split'              , enabled = true},
		{import = 'jaehak.plugins.staline'            , enabled = true},
		{import = 'jaehak.plugins.substitute'         , enabled = true},
		{import = 'jaehak.plugins.telescope'          , enabled = false},
		{import = 'jaehak.plugins.todo-comments'      , enabled = true},
		{import = 'jaehak.plugins.translate'          , enabled = true},
		-- {import = 'jaehak.plugins.vim-illuminate'     , enabled = true},
		{import = 'jaehak.plugins.local-highlight'    , enabled = true},
		{import = 'jaehak.plugins.vim-visual-multi'   , enabled = true},
		{import = 'jaehak.plugins.which-key'          , enabled = true},
		{import = 'jaehak.plugins.yankbank'           , enabled = true},
		{import = 'jaehak.plugins.lsp.autoclose'      , enabled = true},
		{import = 'jaehak.plugins.lsp.comment'        , enabled = true},
		{import = 'jaehak.plugins.lsp.latex'          , enabled = true},
		{import = 'jaehak.plugins.lsp.nvim-treesitter', enabled = true},
		{import = 'jaehak.plugins.lsp.lspsaga'        , enabled = true},
		{import = 'jaehak.plugins.lsp.mason'          , enabled = true},
		{import = 'jaehak.plugins.lsp.nvim-lspconfig' , enabled = true},
		{import = 'jaehak.plugins.lsp.nvim-cmp'       , enabled = true},
		{import = 'jaehak.plugins.lsp.luasnip'        , enabled = true},
		{import = 'jaehak.plugins.lsp.markdown'       , enabled = true},
		{import = 'jaehak.plugins.lsp.nvim-surround'  , enabled = true},
		{import = 'jaehak.plugins.lsp.trouble'        , enabled = true},
		-- {import = 'jaehak.plugins'},
		-- {import = 'jaehak.plugins.lsp'}
	}, {
		change_detection = { notify = false, },
		rocks = { enabled = false, } -- disable lazy.nvim's luarocks supports for fugit2
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


require("jaehak.core.lsp")
