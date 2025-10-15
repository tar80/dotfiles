-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------
local keymap = vim.keymap
local helper = require('helper')

local UNIQUE_NAME = 'rc_dap'
local INFO = vim.log.levels.INFO
local WARN = vim.log.levels.WARN
local JEST_PATH = 'C:/bin/repository/ppmdev/node_modules/jest/bin/jest.js'
local SIGNS = {
  -- DapBreakpoint = '',
  -- DapBreakpointCondition = '',
  -- DapBreakpointRejected = '',
  DapBreakpoint = '',
  DapBreakpointCondition = '',
  DapBreakpointRejected = '',
  DapStopped = '',
}
for sign, icon in pairs(SIGNS) do
  vim.fn.sign_define(sign, { text = icon, texthl = sign, linehl = 'NONE', numhl = 'NONE' })
end

local augroup = vim.api.nvim_create_augroup(UNIQUE_NAME, {})

local _pane = { -- {{{2
  enable = false,
  bufnr = 0,
  winid = 0,
  toggle_term = function(self)
    if self.winid == 0 then
      return
    end

    local is_active = false

    for _, id in ipairs(vim.api.nvim_list_wins()) do
      if id == self.winid then
        is_active = true
        break
      end
    end

    if is_active then
      vim.api.nvim_win_close(self.winid, false)
    else
      local winid = vim.api.nvim_get_current_win()
      vim.cmd(string.format('vertical belowright sbuffer %s|vert resize 60', self.bufnr))
      self.bufnr = vim.api.nvim_get_current_buf()
      self.winid = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(winid)
    end
  end,
  close_term = function(self)
    if self.winid ~= 0 then
      vim.api.nvim_buf_delete(self.bufnr, { force = true })
      self.bufnr = 0
      self.winid = 0
    end
  end,
} -- }}}

local dap = {
  'mfussenegger/nvim-dap',
  lazy = true,
  init = function()
    local with_unique_name = require('tartar.util').name_formatter(UNIQUE_NAME)
    keymap.set('n', '<C-F5>', function()
      local dap = require('dap')
      vim.b.maplocalleader = '\\'
      vim.notify(with_unique_name('%s: ready'), 2)
      ---@desc Defaults {{{2
      -- dap.defaults.fallback.stepping_granularity = 'statement'
      dap.defaults.fallback.terminal_win_cmd = function()
        local winid = vim.api.nvim_get_current_win()
        vim.cmd('belowright 60vsplit new')
        _pane.bufnr = vim.api.nvim_get_current_buf()
        _pane.winid = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(winid)
        return _pane.bufnr, _pane.winid
      end

      ---@desc Autocmds {{{2
      vim.api.nvim_create_autocmd('FileType', { -- {{{2
        group = augroup,
        pattern = 'dap-repl',
        callback = function()
          require('dap.ext.autocompl').attach()
        end,
      })
      vim.api.nvim_create_autocmd('User', { -- {{{2
        group = augroup,
        pattern = 'DapTerminated',
        once = true,
        callback = function()
          dap.clear_breakpoints()
          dap.disconnect()
          dap.repl.close()
          _pane:close_term()
          vim.cmd.DapDetach()
        end,
      })

      ---@desc Js-debug {{{2
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { helper.mason_apps('js-debug-adapter/js-debug/src/dapDebugServer.js'), '${port}' },
          detached = true,
        },
      }

      ---@desc Configurations {{{2
      for _, language in ipairs({ 'typescript', 'javascript' }) do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch',
            program = '${file}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Jest',
            -- trace = true, -- include debugger info
            runtimeExecutable = 'node',
            runtimeArgs = {
              JEST_PATH,
              '--runInBand',
              '--testMatch',
              '**/${fileBasenameNoExtension}.test.${fileExtname}',
            },
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = '_Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end

      ---@desc Event {{{2
      dap.listeners.after.event_initialized['dapui_config'] = function()
        vim.notify(with_unique_name('%s: started'), WARN)
        dap.repl.open({ height = 5 })
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        vim.cmd.doautocmd('<nomodeline> User DapTerminated')
        vim.notify(with_unique_name('%s: terminated'), WARN)
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        vim.notify(with_unique_name('%s: listeners event exited'), WARN)
      end

      ---@Cmd {{{2
      vim.api.nvim_create_user_command('DapAttach', function() -- {{{2
        _pane.enable = true
        keymap.set('n', '<LocalLeader><LocalLeader>', function()
          dap.continue()
        end)
        keymap.set('n', '<LocalLeader>s', function()
          dap.toggle_breakpoint()
        end)
        keymap.set('n', '<LocalLeader>r', function()
          dap.clear_breakpoints()
        end)
        keymap.set('n', '<LocalLeader>t', function()
          _pane:toggle_term()
        end)
        keymap.set('n', '<F8>', function()
          dap.step_over()
        end)
        keymap.set('n', '<F9>', function()
          dap.step_into()
        end)
        keymap.set('n', '<F10>', function()
          dap.step_out()
        end)
      end, {})
      vim.api.nvim_create_user_command('DapDetach', function() -- {{{2
        _pane.enable = false
        keymap.del('n', '<LocalLeader><LocalLeader>')
        keymap.del('n', '<LocalLeader>s')
        keymap.del('n', '<LocalLeader>r')
        keymap.del('n', '<LocalLeader>t')
        keymap.del('n', '<F8>')
        keymap.del('n', '<F9>')
        keymap.del('n', '<F10>')
      end, {})

      ---@Keymaps {{{2
      keymap.set('n', '<C-F5>', function()
        local msg
        if not _pane.enable then
          vim.cmd.DapAttach()
          msg = with_unique_name('%s: attach')
        else
          vim.b.maplocalleader = nil
          vim.cmd.doautocmd('<nomodeline> User DapTerminated')
          msg = with_unique_name('%s: detach')
        end

        vim.notify(msg, INFO, {})
      end)
      -- }}}

      vim.cmd.DapAttach()
    end, { desc = with_unique_name('%s: start') })
  end,
}

local dap_virtual_text = {
  'theHamsta/nvim-dap-virtual-text',
  lazy = true,
  opts = {
    enabled = true,
    enabled_commands = false,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == 'inline' then
        variable.name = ''
      end
      return ('%s = %s'):format(variable.name, variable.value)
    end,
    virt_text_pos = 'inline',
    -- experimental features:
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_lines_above = true,
    virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  },
}

local dap_vscode_js = {
  'mxsdev/nvim-dap-vscode-js',
  lazy = true,
  opts = {
    debugger_path = helper.mason_apps('js-debug-adapter'),
    debugger_cmd = { 'js-debug-adapter' },
    adapters = { 'pwa-node', 'node-terminal', 'pwa-extensionHost' },
  },
}

return { dap, dap_virtual_text, dap_vscode_js }
