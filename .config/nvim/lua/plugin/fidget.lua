-- vim:textwidth=0:foldmethod=marker:foldlevel=1

return {
  'j-hui/fidget.nvim',
  lazy = true,
  init = function()
    vim.api.nvim_create_autocmd('UIEnter', {
      once = true,
      callback = function()
        local msg = ('Startup time: %s'):format(require('lazy').stats().startuptime)
        require('fidget').notify(msg, vim.log.levels.INFO, { annote = '󱎫' })
      end,
    })
    vim.keymap.set('n', 'ms', '<Cmd>Fidget history<CR>', { desc = 'Fidget history' })
    local _fast_event_wrap = require('tartar.helper').fast_event_wrap
    local fidget = require('fidget')
    local notify = fidget.notification.notify
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.print = function(...)
      local info, lines = require('helper').inspect(500, ...)
      local msg = ('[%s]\n%s'):format(info, lines)
      _fast_event_wrap(notify)(msg, vim.log.levels.INFO, {
        key = 'vim.print',
        group = 'messages',
        annote = '',
      })
    end
    print = function(...)
      local msg = tostring(...):gsub('\\n', '\n')
      _fast_event_wrap(notify)(msg, vim.log.levels.INFO, {
        key = 'print',
        group = 'messages',
        annote = '󰢱',
      })
    end
  end,
  opts = {
    progress = {
      poll_rate = 20,
      suppress_on_insert = false,
      ignore_done_already = true,
      ignore_empty_message = false,
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      ignore = {
        function(msg)
          if
            msg.title and msg.title:find('iagnos', 2, true)
            or msg.title:find('semantic', 2, true)
            or msg.title:find('completion', 2, true)
          then
            return true
          end
        end,
      },
      display = {
        render_limit = 5,
        done_ttl = 1,
        done_icon = '󰄬',
        done_style = 'DiagnosticOk',
        progress_ttl = math.huge,
        progress_icon = { pattern = 'pipe', period = 1 },
        progress_style = 'Error',
        group_style = 'DiagnosticInfo',
        icon_style = 'DiagnosticSignInfo',
        priority = 200,
        skip_history = true,
        -- format_message = require('fidget.progress.display').default_format_message,
        format_annote = function(msg)
          return msg.title
        end,
        format_group_name = function(group)
          return tostring(group)
        end,
        overrides = {},
      },
      lsp = {
        progress_ringbuf_size = 0,
        log_handler = false,
      },
    },
    notification = {
      poll_rate = 10,
      filter = vim.log.levels.DEBUG,
      history_size = 128,
      override_vim_notify = true,
      configs = {
        default = {
          name = 'Notifications',
          icon = '󰎟',
          icon_on_left = true,
          ttl = 5,
          update_hook = function(item)
            require('fidget').notification.set_content_key(item)
          end,
          group_style = '@text.emphasis',
          icon_style = '@text.emphasis',
          annote_style = 'Comment',
          debug_style = 'Comment',
          info_style = 'ModeMsg',
          warn_style = 'WarningMsg',
          error_style = 'ErrorMsg',
          -- debug_annote = 'DEBUG',
          -- info_annote = 'INFO',
          -- warn_annote = 'WARN',
          -- error_annote = 'ERROR',
        },
        messages = {
          name = 'Messages',
          icon = '󰋽',
          icon_on_left = true,
          ttl = 3,
          group_style = '@text.emphasis',
          icon_style = '@text.emphasis',
          annote_style = 'ModeMsg',
          update_hook = function(item)
            require('fidget').notification.set_content_key(item)
          end,
        },
      },
      -- redirect = function(msg, level, opts)
      --   if opts and opts.on_open then
      --     return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
      --   end
      -- end,
      view = {
        stack_upwards = true,
        icon_separator = ' ',
        group_separator = '┄┄┄┄┄┄',
        group_separator_hl = 'NonText',
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format('(%dx) %s', cnt, msg)
        end,
      },
      window = {
        normal_hl = 'Comment',
        winblend = 100,
        border = require('tartar.icon.ui').border.bot_dash,
        zindex = 45,
        max_width = 200,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = 'bottom',
        relative = 'editor',
      },
    },
  },
}
