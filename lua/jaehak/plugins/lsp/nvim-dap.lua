
-- ================================
-- Debug sign definition
-- ================================

-- define my own debug sign
---@type table<string, vim.fn.sign_define.dict>
local debug_signs = {
	DapBreakpoint          = { text = '●', texthl = 'DiagnosticError',   linehl = '', numhl = '' },
	DapBreakpointCondition = { text = '●', texthl = 'DiagnosticWarn',    linehl = '', numhl = '' },
	DapBreakpointRejected  = { text = '', texthl = 'DiagnosticHint',    linehl = '', numhl = '' },
	DapLogPoint            = { text = '', texthl = 'DiagnosticInfo',    linehl = '', numhl = '' },
	DapStopped             = { text = '▶', texthl = 'DiagnosticOk',      linehl = 'DapStoppedLine', numhl = '' },
}

-- change debug signs
---@param signs table<string, vim.fn.sign_define.dict>
local set_debug_signs = function(signs)
    for name, opts in pairs(signs) do
        vim.fn.sign_define(name, opts)
    end
end

-- ================================
-- common functions
-- ================================

---@class dap_state
---@field root string? project root absolute path
---@field type string? dap type which is running
local state = {
	root = nil,
	type = nil,
}

--- clear state
local function clear_state()
	state.root = nil
	state.type = nil
end

---@type table<string, string> (dap type name, lsp name to attach to repl)
local lsp_list = {
	python = 'pyrefly',
}

--- find lsp id which is connected to buffer used in debugging session
---@param root string
---@return vim.lsp.Client?
local function get_lsp_client(lsp_name, root)
	local clients = vim.lsp.get_clients({ name = lsp_name})
	for _, client in ipairs(clients) do
		if client.root_dir and (vim.fs.normalize(client.root_dir) == vim.fs.normalize(root)) then
			return client
		end
	end
end

--- get current root project with caching
---@return string absolute path of dap root
local function get_dap_root()
	local utils = require('jaehak.core.utils')
	if not state.root then state.root = utils.GetRoot(0) end
	return state.root
end

--- configure common dap setting
local function configure_dap_common(dap)

	-- set debug signs
	vim.api.nvim_set_hl(0, 'DapStoppedLine', {bg = '#4a3f00'}) -- it must be called after colorschme
	set_debug_signs(debug_signs)

	-- set global state
	dap.listeners.before.launch['common'] = function(session)
		state.root = get_dap_root()
		state.type = session.config.type
	end

	-- clear global state
	dap.listeners.after.event_terminated['common'] = clear_state
	dap.listeners.after.disconnect['common']       = clear_state

	-- attach lsp to repl and set keymap
	vim.api.nvim_create_autocmd('FileType', {
		group   = vim.api.nvim_create_augroup('nvim-dap-common', { clear = true }),
		pattern = { 'dap-repl', 'dap-view' },
		callback = function(args)
			local session = dap.session()
			if not session or session.config.type == 'matlab' then return end

			local bufnr = args.buf
			local lsp_name = lsp_list[state.type]
			if lsp_name and state.root then
				local client = get_lsp_client(lsp_name, state.root)
				if client then
					vim.lsp.buf_attach_client(bufnr, client.id)
					vim.bo[bufnr].syntax = state.type
					vim.diagnostic.enable(false, { bufnr = bufnr })
				else
					vim.notify('[dap] no LSP client: ' .. lsp_name, vim.log.levels.WARN)
				end
			end

			vim.keymap.set('i', '<C-p>', '<Up>', { buffer = bufnr, remap = true, desc = '[dap] prev command history' })
			vim.keymap.set('i', '<C-n>', '<Down>', { buffer = bufnr, remap = true, desc = '[dap] next command history' })
		end,
	})
end


-- ================================
-- dap setting for python
-- ================================

local function configure_dap_python(dap)
	local utils = require('jaehak.core.utils')

	-- configure debug adapter
	-- use debugpy which mason installed
	dap.adapters.python = {
		type = 'executable',
		command = require('jaehak.core.paths').nvim.debugpy_python, -- pythonw must be used to hide debugpy terminal.
		args = { '-m', 'debugpy.adapter' },
		options = {
			source_filetype = 'python', -- [optional] notice to ui that this debugging session is based on python
		}
	}

	-- /////////// configure launch //////////////
	--- check the project uses uv
	---@param root string
	---@return boolean true if root is uv project
	local is_uv = function (root)
		return vim.fn.filereadable(utils.sep_unify(root .. '/uv.lock')) == 1 or
				(vim.fn.filereadable(utils.sep_unify(root .. '/pyproject.toml')) == 1 and
				vim.fn.filereadable(utils.sep_unify(root .. '/poetry.lock')) == 0)
	end

	--- set python path uv or general python
	---@return string python execution path
	local python_path = function ()
		local root = get_dap_root()

		-- if root doesn't be uv project, use general python
		if not root or not is_uv(root) then
			return 'python'
		end

		-- xecutes 'uv sync' to synchronize with pyproject.toml synchronously
		-- it failed, use general python
		local obj = vim.system({'uv', 'sync'}, {text = true, cwd = root}):wait()
		if obj.code ~= 0 then
			vim.notify('uv sync failed', vim.log.levels.ERROR)
			return 'python'
		end

		-- use python in uv project venv
		vim.notify("uv sync successed", vim.log.levels.INFO)
		local py = vim.g.has_win32 and "/.venv/Scripts/python" or "/.venv/bin/python"
		return utils.sep_unify(root .. py)
	end

	--- set environment variables for uv
	---@return table environment variables
	local python_env = function ()
		local root = get_dap_root()
		if not root or not is_uv(root) then return {} end

		local venv_path = utils.sep_unify(root .. '/.venv')
		local bin_path = utils.sep_unify(venv_path .. (vim.g.has_win32 and '/Scripts' or '/bin'))
		return {
			VIRTUAL_ENV = venv_path,
			PATH = bin_path .. ';' .. vim.env.PATH,
		}
	end

	-- [config] launch without args
	local launch_without_args = {
		type = 'python',
		request = 'launch',
		name = "Launch current file",
		program = "${file}",
		pythonPath = python_path,
		env = python_env,
		console = "integratedTerminal",
		-- internalConsole shows new cmd prompt at debug session start. and it is for only output.
		-- integratedTerminal don't show new cmd even we use python instead of pythonw.
		-- and it can interact with user from input(). you can use Console window from nvim-dap-view
		-- REPL / internalConsole is output only. it cannot be used for input.
	}

	local launch_with_args = {
		type = 'python',
		request = 'launch',
		name = "Launch current file:args",
		program = "${file}",
		args = function ()
			local args_string = vim.fn.input({
				prompt = 'Arguments: ',
				completion = 'file',
				cancelreturn = '', -- emtpy value if user cancel
			})
			-- if argument is empty, run without args
			if not args_string or args_string == '' then
				return {}
			end
			vim.fn.histadd('input', args_string) -- save to 'input'(@) register.
			return require("dap.utils").splitstr(args_string)
		end,
		pythonPath = python_path,
		env = python_env,
		console = "integratedTerminal",
	}

	dap.configurations.python = {
		launch_without_args,
		launch_with_args,
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
		-- dap configuration
		-- ================================
		configure_dap_common(dap) -- for all languages excepts of matlab
		configure_dap_python(dap) -- for python

		-- ================================
		-- override dap notify
		-- ================================
		local dap_utils = require('dap.utils')
		local origin_notify = dap_utils.notify
		---@diagnostic disable-next-line: duplicate-set-field
		dap_utils.notify = function (msg, log_level)
			if log_level == vim.log.levels.WARN then
				-- 1) python : disable warning message when python debugger is terminated forcibly
				if msg:match('exited with 1') and msg:match('debugpy') then
					return
				end
			end
			origin_notify(msg, log_level)
		end

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
