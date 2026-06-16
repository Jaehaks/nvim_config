return {
{
	"nvim-lua/plenary.nvim",        -- Required for v0.4.0+
	lazy = true,
},
{
	"nvim-tree/nvim-web-devicons", -- If you want devicons
	lazy = true,
	opts = {
		override_by_extension = {
			['m'] = { icon = '', color = '#FF853B', name = 'matlab' },
			['mat'] = { icon = '', color = '#FF853B', name = 'matlab' },
			['dat'] = { icon = '', color = '#721080', name = 'data' },
		}
	}
},
}
