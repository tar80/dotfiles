return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  keys = {
    {
      '<F13>',
      function()
        local clt = require('copilot.client')
        if not clt:get() then
          print('Not attached cpilot_lsp')
          return
        end
        local state = 'Disebled'
        if clt.buf_is_attached(0) then
          require('copilot.command').detach()
        else
          state = 'Enabled'
          require('copilot.command').attach()
        end
        return print(('%s copilot'):format(state))
      end,
      mode = { 'n', 'i' },
      desc = 'Copilot toggle',
    },
  },
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      filetypes = {
        help = true,
        lua = true,
        typescript = true,
        gitcommit = false,
        ['*'] = false,
      },
      panels = { enable = false },
      suggestions = { enable = false },
      --   auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
      --   logger = {
      --     file = vim.fn.stdpath('log') .. '/copilot-lua.log',
      --     file_log_level = vim.log.levels.OFF,
      --     print_log_level = vim.log.levels.WARN,
      --     trace_lsp = 'off', -- "off" | "messages" | "verbose"
      --     trace_lsp_progress = false,
      --     log_lsp_messages = false,
      --   },
      --   copilot_node_command = 'node', -- Node.js version must be > 20
      --   workspace_folders = {},
      --   copilot_model = '',
      --   root_dir = function()
      --     return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
      --   end,
      --   should_attach = function(_, _)
      --     if not vim.bo.buflisted then
      --       logger.debug("not attaching, buffer is not 'buflisted'")
      --       return false
      --     end
      --
      --     if vim.bo.buftype ~= '' then
      --       logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
      --       return false
      --     end
      --
      --     return true
      --   end,
      --   server = {
      --     type = 'nodejs', -- "nodejs" | "binary"
      --     custom_server_filepath = nil,
      --   },
      --   server_opts_overrides = {},
      -- })
    })
  end,
}
