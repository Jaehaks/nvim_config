-- ================================
-- dap setting for python
-- ================================

local function configure_dap_python(dap)
	-- configure debug adapter
	-- use debugpy which mason installed
	dap.adapters.python = {
		type = 'executable',
		command = require('jaehak.core.paths').nvim.debugpy_python,
		args = { '-m', 'debugpy.adapter' },
		options = {
			source_filetype = 'python', -- [optional] notice to ui that this debugging session is based on python
		}
	}

	local utils = require('jaehak.core.utils')
	-- /////////// configure launch //////////////
	--- check the project uses uv
	local is_uv = function (root)
		return vim.fn.filereadable(utils.sep_unify(root .. '/uv.lock')) == 1 or
				(vim.fn.filereadable(utils.sep_unify(root .. '/pyproject.toml')) == 1 and
				vim.fn.filereadable(utils.sep_unify(root .. '/poetry.lock')) == 0)
	end

	--- set python path uv or general python
	---@return string
	local python_path = function ()
		local root = utils.GetRoot(0)

		-- if root doesn't have uv system, use general python
		if not is_uv(root) then
			return 'python'
		end

		-- if root has uv, executes 'uv sync' to synchronize with pyproject.toml synchronously
		local obj = vim.system({'uv', 'sync'}, {text = true, cwd = root}):wait()
		if obj.code == 0 then
			vim.notify("uv sync successed", vim.log.levels.INFO)
			local py = vim.g.has_win32 and "/.venv/Scripts/python" or "/.venv/bin/python"
			local path = utils.sep_unify(root .. py)
			return path
		else
			vim.notify('uv sync failed', vim.log.levels.ERROR)
			return 'python'
		end
	end

	--- set environment variables for uv
	local python_env = function ()
		local root = utils.GetRoot(0)
		if is_uv(root) then
			local venv_path = utils.sep_unify(root .. '/.venv')
			local bin_path = utils.sep_unify(venv_path .. (vim.g.has_win32 and '/Scripts' or '/bin'))
			return {
				VIRTUAL_ENV = venv_path,
				PATH = bin_path .. ';' .. vim.env.PATH,
			}
		end
		return {}
	end

	-- [config] launch without args
	local launch_without_args = {
		type = 'python',
		request = 'launch',
		name = "Launch file",
		program = "${file}",
		pythonPath = python_path,
		env = python_env,
		-- console = "integratedTerminal",
		console = "internalConsole",
	}

	dap.configurations.python = {
		launch_without_args,
	}
end

-- ================================
-- dap configuration
-- ================================
local dap_ft = {'python', 'matlab'}
return {
{
	'Jaehaks/nvim-dap',
	ft = dap_ft,
	config = function ()
		local dap = require('dap')
		-- dap.set_log_level('TRACE')
		-- ================================
		-- set dap for python
		-- ================================
		configure_dap_python(dap)

		-- ================================
		-- keymap setting
		-- ================================
		vim.keymap.set('n', '<leader>dr', function ()
			local session = dap.session()
			if session and not session.stopped_thread_id then
				dap.close() -- if debug run is completed but session is remaining
			end
			dap.continue()
		end, {desc = '[nvim-dap] Debug Run/continue'})
		vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, {desc = '[nvim-dap] Debug Run to Cursor'})
		vim.keymap.set('n', '<F10>', dap.step_over, {desc = '[nvim-dap] Debug Step Over'})
		vim.keymap.set('n', '<F11>', dap.step_into, {desc = '[nvim-dap] Debug Step Into'})
		vim.keymap.set('n', '<F12>', dap.step_out, {desc = '[nvim-dap] Debug Step Out'})
		vim.keymap.set('n', '<leader>dp', dap.pause, {desc = '[nvim-dap] Debug Pause'})
		vim.keymap.set('n', '<leader>dt', dap.terminate, {desc = '[nvim-dap] Terminate Session'})
		vim.keymap.set('n', '<leader>du', dap.clear_breakpoints, {desc = '[nvim-dap] Clear all Breakpoints'})
		vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {desc = '[nvim-dap] Set Breakpoint '})
		vim.keymap.set('n', '<leader>dB', function ()
			local condition = vim.fn.input('condition : ') -- insert condition without 'if' word.
			if condition and condition ~= '' then
				dap.toggle_breakpoint(condition)
			end
		end, {desc = '[nvim-dap] Set conditional Breakpoint '})
	end
},
{
	'Jaehaks/nvim-dap-matlab',
	ft = {'matlab'},
	dependencies = {
		'Jaehaks/nvim-dap',
	},
	opts = {
		repl = {
			keymaps = {
				previous_command_history = '<C-j>',
				next_command_history = '<C-k>',
			}
		}

	},
},
{
	'igorlfs/nvim-dap-view',
	keys = {
		{'<leader>dv', function () require('dap-view').toggle() end, desc = '[dap-view] Toggle dap view', mode = 'n'}
	},
	ft = dap_ft,
	opts = {
		winbar = {
			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", 'console' },
			default_section = 'repl',
		},
		auto_toggle = true, -- open automatically, remain after normally termination but close after error while debug.
	},
	config = function (_, opts)
		local dap_view = require('dap-view')
		local dap = require('dap')

		dap_view.setup(opts)
		vim.keymap.set('n', '<leader>da', function ()
			local session = dap.session()
			if session and not session.stopped_thread_id then
				dap_view.add_expr()
			end
		end, {desc = '[nvim-dap] Debug Add variable to Watch'})
	end
	-- keymaps-------
	-- breakpoints
	-- 		<CR> : jump to breakpoints
	-- 		d : delete breakpoint
	-- watches
	-- 		<CR> : expand/collapse
	-- 		a : append an expression
	-- 		i : insert an expression
	-- 		d : delete an expression
	-- 		e : edit an expression
	-- 		s : set value
}
}

--[[ Understanding about dap

1) debugpy vs debugpy.adapter

- debugpy is debugger which supports debugging feature. it is executed with target python code.
  It needs to installed where the python program which you executes.

- debugpy.adapter is adapter which has responsibility to communicate between DAP of neovim and debugger.
  It transforms request of DAP command to form which debugpy can understand
  It is executed by independent process. Responsible only for communications

- If you use nvim-dap-python? it just supports how to configure the dap for python and give some more dap functions to useful usage.

2) workflow

nvim-dap -> debugpy.adapter -> debugpy -> python code
debugpy.adapter will create python process from `pythoPath` in configuration.
In this process, debugpy will be loaded automatically when you executes python code.


--]]
