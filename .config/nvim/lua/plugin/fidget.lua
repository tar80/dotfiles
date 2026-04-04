-- workspace=$XDG_DATA_HOME\nvim-data\lazy\fidget.nvim\lua
-- vim:textwidth=0:foldmethod=marker:foldlevel=1

local function open_fidget_history()
  local fidget_notif = require('fidget.notification')
  local history = fidget_notif.get_history()

  if #history == 0 then
    vim.api.nvim_echo({ { 'Fidget: No history available' } }, false, {})
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local ns_id = vim.api.nvim_create_namespace('RcFidgetHistory')

  local FIXED_INDENT_COL = 2

  local all_lines = {}
  local highlights = {}
  local max_content_width = 0

  for _, item in ipairs(history) do
    local raw_time = os.date('%c', item.last_updated)
    local status, time_str = pcall(vim.iconv, raw_time, 'cp932', 'utf-8')
    time_str = (status and time_str) or tostring(raw_time)

    local prefix_chunks = {}
    table.insert(prefix_chunks, { time_str, 'Comment' })
    if item.group_name and #item.group_name > 0 then
      table.insert(prefix_chunks, { ' ', 'Normal' })
      table.insert(prefix_chunks, { item.group_name, 'Special' })
    end

    table.insert(prefix_chunks, { ' | ', 'Comment' })

    if item.annote and #item.annote > 0 then
      table.insert(prefix_chunks, { item.annote, item.style or 'Question' })
      table.insert(prefix_chunks, { ' ', 'Normal' })
    end

    local prefix_text = ''
    for _, c in ipairs(prefix_chunks) do
      prefix_text = prefix_text .. c[1]
    end

    local msg_lines = vim.split(item.message, '\n', { trimempty = true })

    for i, msg_line in ipairs(msg_lines) do
      local line_idx = #all_lines
      local current_line_text = ''

      if i == 1 then
        for _, chunk in ipairs(prefix_chunks) do
          local start_col = #current_line_text
          current_line_text = current_line_text .. chunk[1]
          table.insert(highlights, { line_idx, start_col, #current_line_text, chunk[2] })
        end

        local current_w = vim.fn.strdisplaywidth(current_line_text)
        local padding_n = math.max(1, FIXED_INDENT_COL - current_w)
        current_line_text = current_line_text .. string.rep(' ', padding_n)
      else
        current_line_text = string.rep(' ', FIXED_INDENT_COL)
      end

      local last_pos = 1
      for start_idx, end_idx, content in msg_line:gmatch('()@%*%*(.-)%*%*()') do
        if start_idx > last_pos then
          current_line_text = current_line_text .. msg_line:sub(last_pos, start_idx - 1)
        end
        local hl_start = #current_line_text
        current_line_text = current_line_text .. content
        table.insert(highlights, { line_idx, hl_start, #current_line_text, 'DiagnosticWarn' })
        last_pos = end_idx
      end
      current_line_text = current_line_text .. msg_line:sub(last_pos)

      table.insert(all_lines, current_line_text)
      max_content_width = math.max(max_content_width, vim.fn.strdisplaywidth(current_line_text))
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, all_lines)

  local ui_width, ui_height = vim.o.columns, vim.o.lines
  local win_width = math.min(max_content_width + 4, math.floor(ui_width * 0.9))
  local win_height = math.min(#all_lines, math.floor(ui_height * 0.7))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = math.floor((ui_height - win_height) / 2),
    col = math.floor((ui_width - win_width) / 2),
    style = 'minimal',
    border = 'rounded',
    focusable = true,
  })

  for _, h in ipairs(highlights) do
    vim.api.nvim_buf_set_extmark(buf, ns_id, h[1], h[2], { end_col = h[3], hl_group = h[4] })
  end

  vim.api.nvim_set_option_value('filetype', 'fidget_history', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('winblend', 5, { win = win })
  vim.api.nvim_set_option_value('cursorline', true, { win = win })
  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true, nowait = true })

  if #all_lines > 0 then
    vim.api.nvim_win_set_cursor(win, { #all_lines, 0 })
  end
end

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
    vim.keymap.set('n', 'ms', open_fidget_history, { desc = 'Fidget History' })
    local _fast_event_wrap = require('tartar.helper').fast_event_wrap
    local fidget = require('fidget')
    local notify = fidget.notification.notify
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.print = function(...)
      local info, lines = require('helper').inspect(false, 2000, ...)
      local msg = ('[%s]\n%s'):format(info, lines)
      _fast_event_wrap(notify)(msg, vim.log.levels.INFO, {
        key = 'vim.print',
        group = 'messages',
        annote = '',
      })
    end
    print = function(...)
      local info, lines = require('helper').inspect(true, 2000, ...)
      local msg = ('[%s]\n%s'):format(info, lines)
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
            msg and msg.title and msg.title:find('iagnos', 2, true)
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
          icon_style = 'FidgetInfo',
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
