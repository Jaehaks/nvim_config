return {
	-- substitute contents automatically from default register
	'gbprod/substitute.nvim',
	keys = {
		{'s' , function() require('substitute').operator() end , desc = 'substitute operator', mode = {'n'}, noremap = true},
		{'ss', function() require('substitute').line()     end , desc = 'substitute line'    , mode = {'n'}, noremap = true},
		{'S' , function() require('substitute').eol()      end , desc = 'substitute eol'     , mode = {'n'}, noremap = true},
		{'s' , function() require('substitute').visual()   end , desc = 'substitute visual'  , mode = {'x'}, noremap = true},
	},
	opts = {
	}
}
