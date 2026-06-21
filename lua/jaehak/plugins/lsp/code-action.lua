return {
{
	"iilw/nui-diagnostic.nvim", -- need nui.nvim
	keys = {
		{'ga', function () require('nui-diagnostic').next() end, mode = 'n', desc = 'Display Code action'}
	},
	opts = {
		keymaps = {
			enabled = false,
		}
	}
}
}

-- Chaitanyabsprip/fastaction.nvim : it doesn't support going to next diagnostic and show code action
-- 								     it shows code action for current cursor location only.
