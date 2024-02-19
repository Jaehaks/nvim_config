return {
{
	'altermo/ultimate-autopair.nvim',
	event = {'InsertEnter', 'CmdlineEnter'},
	branch = 'v0.6',
	opts = {},
},
{
	'luochen1990/rainbow',
	config = function()
		vim.g.rainbow_active = 1
	end
}
}

