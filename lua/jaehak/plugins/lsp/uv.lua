return {
	'Jaehaks/uv.nvim',
	ft = {'python'},
	opts = {
		auto_commands = true, 			-- activate venv whenever cwd is changed. User must set project root as pwd
		auto_activate_venv = true,		-- activate venv if it is in current project root (once)
		notify_activate_venv = false,	-- notify when .venv is detected

		-- Integration with snacks picker
		picker_integration = true,

		-- Keymaps to register (set to false to disable)
		keymaps = {
			prefix = "<leader>u", -- Main prefix for uv commands
			commands = true,      -- Show uv commands menu (<leader>x)
			run_file = true,      -- Run current file (<leader>xr)
			run_selection = true, -- Run selected code (<leader>xs)
			run_function = true,  -- Run function (<leader>xf)
				venv = true,      -- Environment management (<leader>xe)
				init = true,      -- Initialize uv project (<leader>xi)
				add = true,       -- Add a package (<leader>xa)
				remove = true,    -- Remove a package (<leader>xd)
				sync = true,      -- Sync packages (<leader>xc)
				sync_all = true,  -- Sync all packages, extras and groups (<leader>xC)
			},

			-- Execution options when :UVRun~ command
			execution = {
				run_command = "uv run ipython -i", -- open python interactive shell After run
												   -- base 'python' doesn't support completion. use ipython
				notify_output = true, -- Show output in notifications
				notification_timeout = 10000, -- Notification timeout in ms
			},
	}
}
