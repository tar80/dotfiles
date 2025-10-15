-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local icon = require('icon')

---@param sep_l string Left spearator
---@param sep_r string Right spearator
---@param hlgroup string Hlgroup
local function create_border(sep_l, sep_r, hlgroup)
  local l = sep_l and { sep_l, hlgroup } or ''
  local r = sep_r and { sep_r, hlgroup } or ''
  return { '', '', '', r, '', '', '', l }
end

local border = { -- {{{2
  notify = create_border(icon.sep.bubble.l, icon.sep.bubble.r, 'NoiceMiniHintReverse'),
  warn = create_border(icon.sep.bubble.l, icon.sep.bubble.r, 'NoiceMiniWarnReverse'),
  error = create_border(icon.sep.bubble.l, icon.sep.bubble.r, 'NoiceMiniErrorReverse'),
} -- }}}2

-- {{{2 any_wrap()
---@param ... table
local function any_wrap(...)
  local tbl = { ... }
  local any = {}
  for i, t in ipairs(tbl) do
    if type(t[i]) == 'table' then
      vim.iter(t):each(function(filter)
        table.insert(any, filter)
      end)
    else
      table.insert(any, t)
    end
  end
  return any
end

-- {{{2 filter_wrap()
---@param finds string[]
local function filter_wrap(event, kind, finds)
  local filters = {}
  vim.iter(finds):each(function(find)
    table.insert(filters, { event = event, kind = kind, find = find })
  end)
  return filters
end
-- }}}2

return {
  { 'MunifTanjim/nui.nvim', lazy = true },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    keys = { -- {{{2
      {
        '<C-j>',
        mode = { 'c' },
        function()
          require('noice').redirect(vim.fn.getcmdline())
        end,
        desc = 'Noice redirect cmdline',
      },
      {
        '<Down>',
        mode = { 'n', 'i', 's' },
        function()
          if not require('noice.lsp').scroll(4) then
            return '<Down>'
          end
        end,
        expr = true,
        desc = 'Noice hacked Down',
      },
      {
        '<Up>',
        mode = { 'n', 'i', 's' },
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<Up>'
          end
        end,
        expr = true,
        desc = 'Noice hacked Up',
      },
      {
        'ma',
        mode = { 'n' },
        '<Cmd>NoiceAll<CR>',
        desc = 'Noice all log',
      },
      {
        'ms',
        mode = { 'n' },
        '<Cmd>Noice history<CR>',
        desc = 'Noice messages',
      },
    }, -- }}}2
    opts = { -- {{{2
      throttle = 1000 / 30,
      health = { checker = false },
      status = {},
      cmdline = { -- {{{3
        enabled = true,
        view = 'cmdline',
        opts = {},
        format = {
          cmdline = { pattern = '^:', icon = icon.symbol.input, lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = icon.symbol.search_down, lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = icon.symbol.search_up, lang = 'regex' },
          input = { view = 'cmdline', icon = icon.lazy.cmd },
          lua = false,
          filter = false,
          help = false,
          -- input = false,
          error = {
            conceal = false,
            pattern = '^:vim%.',
            icon = icon.state.failure,
            icon_hl_group = 'Error',
            lang = '',
          },
        },
      }, -- }}}3
      notify = { enabled = true, view = 'notify' },
      lsp = { -- {{{3
        progress = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = false,
          ['cmp.entry.get_documentation'] = false,
        },
        signature = {
          enabled = false,
          auto_open = { enabled = true, trigger = true, luasnip = false, throttle = 50 },
          view = nil,
          opts = {
            replace = true,
            render = 'plain',
            format = { '{message}' },
            win_options = { concealcursor = 'n', conceallevel = 3 },
          },
        },
      }, -- }}}3
      popupmenu = {
        enabled = true,
        backend = 'cmp',
        kind_icons = {},
      },
      presets = { -- {{{3
        bottom_search = true,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = true,
      }, -- }}}3
      redirect = { view = 'popup', filter = { event = 'msg_show' } },
      commands = { -- {{{3
        history = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
          filter = {
            any = {
              { event = 'notify' },
              { error = true },
              { warning = true },
              { event = 'msg_show', kind = { 'list_cmd', 'lua_print', 'echo' } },
              { event = 'lsp', kind = 'message' },
            },
          },
        },
        all = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
          filter = {},
        },
      }, -- }}}3
      messages = { -- {{{3
        enabled = true,
        view = 'notify',
        view_warn = 'warn',
        view_error = 'error',
        view_history = 'popup',
        view_search = false,
      }, -- }}}
      routes = { -- {{{3
        {
          view = 'notify',
          filter = { cmdline = true, event = 'msg_show', kind = { 'list_cmd', 'lua_print', 'echo' } },
        },
        {
          opts = { skip = true },
          filter = {
            any = any_wrap(
              { event = 'lsp', kind = 'progress', find = 'iagnos' },
              { event = 'msg_show', kind = 'echomsg', find = 'Replaced' },
              filter_wrap('msg_show', { '', 'lua_print' }, { 'written', '; after', '; before', 'lines' })
            ),
          },
        },
      }, -- }}}3
      views = { -- {{{3
        hover = { -- {{{4
          view = 'popup',
          relative = 'cursor',
          zindex = 45,
          enter = false,
          anchor = 'auto',
          size = {
            width = 'auto',
            height = 'auto',
            max_height = 7,
            max_width = 120,
          },
          border = {
            style = icon.border.quotation,
            padding = { 0, 1 },
          },
          position = { row = 1, col = 0 },
          win_options = {
            wrap = true,
            linebreak = true,
          },
        }, -- }}}
        cmdline = { -- {{{4
          backend = 'popup',
          relative = 'editor',
          position = { row = '100%', col = 0 },
          size = { height = 'auto', width = '100%' },
          border = { style = 'none' },
          win_options = {
            winblend = 50,
            winhighlight = { Normal = 'NoiceCmdline', IncSearch = '', CurSearch = '', Search = '' },
          },
        }, -- }}}4
        notify = { -- {{{4
          format = { '  {message} ' },
          backend = 'mini',
          relative = 'editor',
          align = 'message-left',
          timeout = 2500,
          reverse = false,
          focusable = false,
          position = { row = -1, col = 0 },
          size = { width = 'auto', height = 'auto', max_height = 20 },
          border = { style = border.notify },
          zindex = 50,
          win_options = {
            winblend = 0,
            winhighlight = { Normal = 'NoiceMiniHint', IncSearch = '', CurSearch = '', Search = '' },
          },
        }, -- }}}
        warn = { -- {{{4
          format = { { icon.severity.Warn, hl_group = 'NoiceMiniWarn' }, ' {message} ' },
          backend = 'mini',
          relative = 'editor',
          align = 'message-right',
          timeout = 5000,
          reverse = false,
          focusable = false,
          position = { row = -1, col = '100%' },
          size = { width = 'auto', height = 'auto', max_height = 5, max_length = 100, min_length = 20 },
          border = { style = border.warn },
          zindex = 20,
          win_options = {
            winblend = 0,
            winhighlight = { Normal = 'NoiceMiniWarn', IncSearch = '', CurSearch = '', Search = '' },
          },
        }, -- }}}
        error = { -- {{{4
          format = { { icon.severity.Error, hl_group = 'NoiceMiniError' }, ' {message} ' },
          backend = 'mini',
          relative = 'editor',
          align = 'message-right',
          timeout = 7000,
          reverse = false,
          focusable = false,
          position = { row = -1, col = '100%' },
          size = { width = 'auto', height = 'auto', max_height = 10, max_length = 120, min_length = 20 },
          border = { style = border.error },
          zindex = 10,
          win_options = {
            winblend = 0,
            winhighlight = { Normal = 'NoiceMiniError', IncSearch = '', CurSearch = '', Search = '' },
          },
        }, -- }}}
      }, -- }}}3
      format = { -- {{{3
        level = { icons = { error = icon.severity.Error, warn = icon.severity.Warn, info = icon.severity.Info } },
        spinner = { name = 'pipe', hl_group = nil },
        details = {
          '{date} ',
          '{event}',
          { '{kind}', before = { '.', hl_group = 'NoiceFormatKind' } },
          ' ',
          '{level} ',
          '{title} ',
          '{cmdline} ',
          '{message}',
        },
      }, -- }}}3
    }, -- }}}2
    config = function(_, opts) -- {{{2
      require('noice').setup(opts)
      vim.schedule(function()
        local msg = ('Startup time: %s'):format(require('lazy').stats().startuptime)
        vim.notify(msg, 1)
      end)
    end, -- }}}2
  },
}
