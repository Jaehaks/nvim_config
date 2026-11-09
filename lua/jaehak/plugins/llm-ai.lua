return {
{
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		focus_after_send = false,
		track_selection = false,
		terminal = {
			split_side = 'right', -- for native provider
			split_width_percentage = 0.40,
			provider = 'snacks',
			snacks_win_opts = { -- terminal option for snacks @snacks.win.Config
				position = 'bottom',
				height = 0.4,
				width = 1.0,
			}
		},
		env = { -- env vars for only claude code session
			-- WARN: Don't insert EDITOR/VISUAL env in settings.json of claude code. use global environment variables
			-- INFO: open external editor nvim buffer to current nvim instance.
			EDITOR = 'nvim --clean -l ' .. require('jaehak.core.paths').nvim.ext_editor,
			-- FIXME: when I use terminal nvim as external editor, close time is too long
			-- FIXME: I don't know what is the reason. (lsp, gitsigns are not.)
			-- EDITOR = 'nvim-qt',
		},
	},
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeStatus",
		"ClaudeCodeStart",
		"ClaudeCodeStop",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffs",
	},
	keys = {
		{ "<M-/>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude", mode = {'n', 't'} },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file from file picker",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
		},
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
	config = function (_, opts)
		require('claudecode').setup(opts)

		--- Send visual selection range to Claude as @File#LStart-End
		local function claudevisualadd()
			local s, e = vim.fn.line('v'), vim.fn.line('.')
			if s > e then s, e = e, s end
			vim.cmd('normal! \27')  -- exit visual mode
			local file = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
			vim.cmd(('ClaudeCodeAdd %s %d %d'):format(file, s, e))
		end

		--- keymap
		vim.keymap.set('x', '<leader>as', claudevisualadd, { desc = 'Send selection to Claude' })
	end

	-- <C-o> in claude : 'scroll mode' in terminal
	-- 					 In normal mode, the cursor can be moved but it doesn't mean that is can scroll.
	-- 					 scroll mode is independent feature in native Claude
	-- 					 put 'q' to go out from scroll mode
	-- 					 'g', 'G', 'j' 'k', 'c-d', 'c-u' is supported
	-- 					 you can change keybindings in ~/.claude/keybindings.json
}
}
