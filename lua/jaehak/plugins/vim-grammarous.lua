return {
{
	'rhysd/vim-grammarous',
	enabled = false,
	dependencies = {
		'Shougo/vimproc.vim',
		'Shougo/unite.vim',
		'kana/vim-operator-user'
	},
	-- vim plugin cannot use lazy load
	config = function()
		vim.g['grammarous#default_comments_only_filetypes'] = {
			['*'] = 1,
			['help'] = 0,
		}
		vim.g['grammarous#languagetool_cmd'] = 'java -jar C:\\Users\\USER\\Documents\\My_installer_file\\LanguageTool-5.9\\languagetool-commandline.jar'
		vim.keymap.set({'n', 'v'}, '<leader>tg', '<Cmd>GrammarousCheck --lang=en-US <CR>', {desc = 'Check grammar'})
	end
},
{
	'dpelle/vim-LanguageTool',
	enabled = false,
	config = function ()
		vim.g.languagetool_jar = 'C:\\Users\\USER\\Documents\\My_installer_file\\LanguageTool-5.9\\languagetool-commandline.jar'
	end
}
}
-- 'dpelle/vim-LanguageTool' : it show grammar error list in temporal buffer,
-- 							   it works with under LanguageTool-5.9 because of --api option does not exist in latest version
-- 							   languageTool's grammar is not exact what i want..
-- 							   I have to modify the grammar error manually
--
-- 							   i doesn't change any something.
-- 'vim-grammarous' : it use languagetool also, Accuracy is too low 
-- 'grammarly lsp' : documents are shared with them
