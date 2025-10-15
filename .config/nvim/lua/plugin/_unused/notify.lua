return {
  'rcarriga/nvim-notify',
  enabled = true,
  event = 'VeryLazy',
  opts = function(_, opts)
    vim.notify = require('notify')
    vim.api.nvim_create_autocmd('LspProgress', {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
          id = 'lsp_progress',
          title = 'LSP Progress',
          opts = function(notif)
            notif.icon = ev.data.params.value.kind == 'end' and ' '
              or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })
    local _opts = {
      background_colour = 'NotifyBackground',
      fps = 30,
      icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '',
        WARN = '',
      },
      level = 2,
      minimum_width = 50,
      render = 'wrapped-compact',
      stages = 'fade',
      time_formats = {
        notification = '%T',
        notification_history = '%FT%T',
      },
      timeout = 5000,
      top_down = true,
    }
    return vim.tbl_deep_extend('force', opts, _opts)
  end,
}
