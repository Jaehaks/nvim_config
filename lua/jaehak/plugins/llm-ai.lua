--- highlight mentions in external editor
local function set_claude_autocmd()
	vim.api.nvim_set_hl(0, "ClaudeMention", { fg = "#81d02a", bold = true })

	local pat = [[\v(^|\s)\zs\@\S+]]  -- @path, @path#L1-10

	vim.api.nvim_create_autocmd("BufWinEnter", {
		pattern = "*claude-prompt-*.md",
		callback = function()
			if not vim.w.claude_mention then
				vim.w.claude_mention = vim.fn.matchadd("ClaudeMention", pat)
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWinLeave", {
		pattern = "*claude-prompt-*.md",
		callback = function()
			if vim.w.claude_mention then
				pcall(vim.fn.matchdelete, vim.w.claude_mention)
				vim.w.claude_mention = nil
			end
		end,
	})
end

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

		local cc = require('claudecode')
		cc.setup(opts)

		--- Redefine 'ClaudeCodeAdd' : While external editor is open, put @mention into its buffer instead of Claude
		local send_at_mention = cc.send_at_mention -- backup original version
		---@diagnostic disable-next-line: duplicate-set-field
		cc.send_at_mention = function(file_path, s, e, context)
			local eb = package.loaded['jaehak.core.ext_editor_buf'] -- get external editor's bufnr
			local bufnr = eb and eb.bufnr

			-- if external editor is not open, send the mention to claude code terminal
			if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
				return send_at_mention(file_path, s, e, context)
			end

			-- formatting file_path using claude code api
			local ok, path, is_dir = pcall(cc._format_path_for_at_mention, file_path)
			if not ok then return false, path end
			local text = '@' .. path
			if s and not is_dir then -- s, e are 0-indexed
				text = text .. '#L' .. (s + 1) .. ((e and e ~= s) and ('-' .. (e + 1)) or '')
			end

			-- append to the end of the last line
			local last = vim.api.nvim_buf_line_count(bufnr)
			local line = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, false)[1]
			local sep = (line == '' or line:match('%s$')) and '' or ' '
			vim.api.nvim_buf_set_text(bufnr, last - 1, #line, last - 1, #line, { sep .. text .. ' ' })
			return true
		end

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

		--- autocmd
		set_claude_autocmd()
	end

	-- <C-o> in claude : 'scroll mode' in terminal
	-- 					 In normal mode, the cursor can be moved but it doesn't mean that is can scroll.
	-- 					 scroll mode is independent feature in native Claude
	-- 					 put 'q' to go out from scroll mode
	-- 					 'g', 'G', 'j' 'k', 'c-d', 'c-u' is supported
	-- 					 you can change keybindings in ~/.claude/keybindings.json
}
}
