-- t : auto wrapping with textwidth setting in the middle of editing
-- c : wrapping with commentstring if current line is comment
-- q : if use 'gq', only do Line break
-- j : If 'J' to join two lines, add only one white space
-- r : If <CR>, commentstring of previous line is added automatically
-- l : auto wrapping but not in the middle of editing, when use use 'gq'
vim.opt_local.formatoptions = 'jcroql'
vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
