local symbol = require('tartar.icon.symbol')

local EXCLUED_FILES = {
  'lazy-lock.json',
  '*.exe',
  '*.dll',
  '*.EXE',
  '*.DLL',
  '.bundle[/\\]',
  '.gems[/\\]',
  '.obsidian[/\\]',
  '.trash[/\\]',
  'dist[/\\]',
  'node_modules[/\\]',
  'migemo[/\\]',
  'themes[/\\]',
  'vendor[/\\]',
}

local bigfile_opts = { -- {{{2
  enabled = true,
  notify = true,
  size = 1.5 * 1024 * 1024, -- 1.5MB
  line_length = 1000,
  -- Enable or disable features when big file detected
  ---@param ctx {buf: number, ft:string}
  setup = function(ctx)
    if vim.fn.exists(':NoMatchParen') ~= 0 then
      vim.cmd('NoMatchParen')
    end
    Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        vim.bo[ctx.buf].syntax = ctx.ft
      end
    end)
  end,
} -- }}}2
local image_opts = { -- {{{2
  formats = { 'png' },
  force = false,
  doc = { enabled = true, inline = false, float = true, max_width = 60, max_height = 30 },
  img_dirs = { 'img', 'images', 'assets', 'static', 'public', 'media', 'attachments' },
  cache = vim.fn.stdpath('cache') .. '/snacks/image',
  debug = { request = false, convert = false, placement = false },
  env = {},
  icons = { math = '󰪚 ', chart = '󰄧 ', image = ' ' },
  convert = { notify = false, magick = false },
  math = { enabled = false },
} -- }}}2
local input_opts = { -- {{{2
  icon = '',
  icon_hl = 'SnacksInputIcon',
  icon_pos = 'left',
  prompt_pos = 'title',
  win = { style = 'input' },
  expand = true,
} -- }}}2
local notifier_opts = { -- {{{2
  timeout = 3000,
  width = { min = 30, max = 0.4 },
  height = { min = 1, max = 0.6 },
  margin = { top = 0, right = 1, bottom = 0 },
  padding = true, -- add 1 cell of left/right padding to the notification window
  sort = { 'level', 'added' },
  level = vim.log.levels.TRACE,
  icons = symbol.log_levels,
  style = 'compact',
  top_down = true,
  date_format = '%R',
  more_format = ' ↓ %d lines ',
  refresh = 200,
} -- }}}2
local picker_opts = { -- {{{2
  prompt = symbol.cmdline.input .. ' ',
  jump = { -- {{{3
    jumplist = true, -- save the current position in the jumplist
    tagstack = false, -- save the current position in the tagstack
    reuse_win = false, -- reuse an existing window if the buffer is already open
    close = true, -- close the picker when jumping/editing to a location (defaults to true)
    match = false, -- jump to the first match position. (useful for `lines`)
  }, -- }}}3
  layout = { -- {{{3
    backdrop = false,
    cycle = false,
    preset = function()
      return vim.o.columns >= 120 and 'default' or 'vertical'
    end,
  }, -- }}}3
  matcher = { -- {{{3
    fuzzy = true,
    smartcase = false,
    ignorecase = true,
    sort_empty = false,
    filename_bonus = true,
    file_pos = false,
    cwd_bonus = false,
    frecency = true,
    history_bonus = false,
  }, -- }}}3
  sort = {
    fields = { 'score:desc', '#text' },
  },
  ui_select = true,
  win = { -- {{{3
    input = {
      keys = {
        ['<Esc>'] = 'cancel',
        ['<CR>'] = { 'confirm', mode = { 'i', 'n' } },
        ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'i', 'n' } },
        ['<C-g>'] = { 'close', mode = { 'i', 'n' } },
        ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
        ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
        ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
        ['+'] = { 'flash', mode = { 'i', 'n' } },
        ['<S-k>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<S-j>'] = { 'list_down', mode = { 'i', 'n' } },
        ['<S-l>'] = { 'focus_list', mode = { 'i', 'n' } },
        ['<S-p>'] = { 'focus_preview', mode = { 'i', 'n' } },
        ['<C-a>'] = { '<home>', mode = { 'i' }, expr = true },
        ['<C-e>'] = { '<End>', mode = { 'i' }, expr = true },
        ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        ['<C-b>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
        ['<C-f>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
        ['<C-q>'] = { 'qflist', mode = { 'i', 'n' } },
        ['<C-s>'] = { 'split', mode = { 'i', 'n' } },
        ['<C-t>'] = { 'tab', mode = { 'i', 'n' } },
        ['<C-v>'] = { 'vsplit', mode = { 'i', 'n' } },
        -- ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
        -- ['<A-d>'] = { 'inspect', mode = { 'i', 'n' } },
        -- ['<A-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
        -- ['<A-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
        -- ['<A-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        -- ['<A-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
        -- ['<A-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
        ['<A-w>'] = false,
        -- ['?'] = 'toggle_help_input',
        -- ['G'] = 'list_bottom',
        -- ['gg'] = 'list_top',
        -- ['j'] = 'list_down',
        -- ['k'] = 'list_up',
        -- ['q'] = 'close',
      },
    },
    list = {
      keys = {
        -- ['<2-LeftMouse>'] = 'confirm',
        -- ['<Esc>'] = 'cancel',
        -- ['/'] = 'toggle_focus',
        ['<CR>'] = 'confirm',
        ['<Up>'] = 'list_up',
        ['<Down>'] = 'list_down',
        ['<S-Tab>'] = { 'select_and_prev', mode = { 'n', 'x' } },
        ['<Tab>'] = { 'select_and_next', mode = { 'n', 'x' } },
        ['+'] = 'flash',
        ['<S-p>'] = { 'focus_preview', mode = { 'i', 'n' } },
        ['<C-a>'] = 'select_all',
        ['<C-u>'] = 'preview_scroll_up',
        ['<C-d>'] = 'preview_scroll_down',
        ['<C-b>'] = 'list_scroll_up',
        ['<C-f>'] = 'list_scroll_down',
        -- ['<C-q>'] = 'qflist',
        -- ['<C-s>'] = 'edit_split',
        -- ['<C-t>'] = 'tab',
        -- ['<C-v>'] = 'edit_vsplit',
        -- ['<A-f>'] = 'toggle_follow',
        -- ['<A-h>'] = 'toggle_hidden',
        -- ['<A-i>'] = 'toggle_ignored',
        -- ['<A-m>'] = 'toggle_maximize',
        -- ['<A-p>'] = 'toggle_preview',
        ['<A-w>'] = false,
        ['/'] = false,
        -- ['?'] = 'toggle_help_list',
        -- ['G'] = 'list_bottom',
        -- ['gg'] = 'list_top',
        -- ['i'] = 'focus_input',
        -- ['j'] = 'list_down',
        -- ['k'] = 'list_up',
        -- ['q'] = 'close',
      },
    },
    preview = {
      keys = {
        ['<Esc>'] = 'cancel',
        ['q'] = 'close',
        ['i'] = 'focus_input',
        ['+'] = 'flash',
        ['<ScrollWheelDown>'] = 'list_scroll_wheel_down',
        ['<ScrollWheelUp>'] = 'list_scroll_wheel_up',
        ['<S-l>'] = { 'focus_list', mode = { 'i', 'n' } },
        ['<A-w>'] = false,
        ['/'] = false,
      },
      wo = {
        conceallevel = 2,
        concealcursor = 'nc',
      },
    },
  }, -- }}}3
  actions = { -- {{{3
    flash = function(picker)
      require('flash').jump({
        pattern = '^',
        label = { after = { 0, 0 } },
        search = {
          mode = 'search',
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
            end,
          },
        },
        action = function(match)
          local idx = picker.list:row2idx(match.pos[1])
          picker.list:_move(idx, true, true)
        end,
      })
    end,
  }, -- }}}3
  formatters = { -- {{{3
    text = {
      ft = nil, ---@type string? filetype for highlighting
    },
    file = {
      filename_first = false,
      truncate = 40,
      filename_only = false,
      icon_width = 3,
      git_status_hl = true,
    },
    selected = {
      show_always = false,
      unselected = false,
    },
    severity = {
      icons = true,
      level = false,
      pos = 'left',
    },
  }, -- }}}3
  layouts = { -- {{{3
    default = {
      layout = {
        box = 'horizontal',
        width = 0.8,
        min_width = 120,
        height = 0.8,
        {
          box = 'vertical',
          border = 'single',
          title = '{title} {flags}',
          { win = 'input', height = 1, border = 'bottom' },
          { win = 'list', border = 'none' },
        },
        { win = 'preview', title = '{preview}', border = 'single', width = 0.6 },
      },
    },
    dropdown = {
      layout = {
        row = 1,
        width = 0.5,
        min_width = 81,
        height = 0.9,
        border = 'none',
        box = 'vertical',
        {
          box = 'vertical',
          border = 'single',
          title = '{title}',
          title_pos = 'center',
          { win = 'input', height = 1, border = 'bottom' },
          { win = 'list', border = 'none' },
        },
        {
          win = 'preview',
          title = '{preview}',
          height = 0.7,
          border = 'single',
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'no',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        },
      },
    },
    registers = {
      layout = {
        row = 1,
        width = 0.5,
        min_width = 81,
        height = 0.9,
        border = 'none',
        box = 'vertical',
        {
          win = 'preview',
          title = '{preview}',
          height = 0.2,
          border = 'single',
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'no',
            statuscolumn = ' ',
            conceallevel = 0,
          },
        },
        {
          box = 'vertical',
          border = 'single',
          title = '{title}',
          title_pos = 'center',
          { win = 'input', height = 1, border = 'bottom' },
          { win = 'list', border = 'none' },
        },
      },
    },
    sideview = {
      preview = 'main',
      layout = {
        width = 80,
        min_width = 80,
        height = 0,
        position = 'left',
        border = 'none',
        box = 'vertical',
        { win = 'list', border = 'none' },
        { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
      },
    },
    vscode = {
      preview = false,
      layout = {
        row = 1,
        width = 0.4,
        min_width = 80,
        height = 0.9,
        border = 'none',
        box = 'vertical',
        { win = 'input', height = 1, border = 'single', title = '{title} {flags}', title_pos = 'center' },
        { win = 'list', border = 'single' },
        { win = 'preview', title = '{preview}', border = 'single' },
      },
    },
  }, -- }}}3
  previewers = { -- {{{3
    diff = {
      builtin = true,
      cmd = { 'delta' },
    },
    git = {
      builtin = true,
      args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
    },
    file = {
      max_size = 1024 * 1024, -- 1MB
      max_line_length = 500, -- max line length
      ft = nil,
    },
    man_pager = nil,
  }, -- }}}3
  sources = { -- {{{3
    explorer = { -- {{{4
      auto_close = true,
      hidden = true,
      ignored = true,
      diagnostics = false,
      diagnostics_open = false,
      exclude = EXCLUED_FILES,
      focus = 'input',
      follow_file = false,
      formatters = { file = { filename_only = false } },
      git_status = true,
      git_status_open = false,
      git_untracked = true,
      jump = { close = true },
      layout = { preset = 'default', preview = true },
      matcher = { sort_empty = false, fuzzy = true },
      sort = { fields = { 'sort' } },
      supports_live = false,
      tree = false,
      watch = false,
      actions = {
        git_rm = function(picker)
          local tree = require('snacks.explorer.tree')
          local items = picker:selected({ fallback = true })
          local done = 0
          for _, item in ipairs(items) do
            local cmd = { 'git', 'rm', '--cached', item.file }
            Snacks.picker.util.cmd(cmd, function(data, code)
              done = done + 1
              if done == #items then
                tree:refresh(vim.fs.dirname(item.file))
                vim.defer_fn(function()
                  if picker and not picker.closed and tree:is_dirty(picker:cwd(), picker.opts) then
                    if not picker.list.target then
                      picker.list:set_target()
                    end
                    vim.schedule(function()
                      picker.list:set_selected()
                      picker.list:set_target()
                      picker:find()
                    end)
                  end
                end, 100)
              end
            end, { cwd = item.cwd })
          end
        end,
      },
      win = {
        input = {
          keys = {
            -- ['<CR>'] = { 'jump', mode = { 'i', 'n' } },
            -- ['<C-s>'] = { 'edit_split', mode = { 'i', 'n' } },
            -- ['<C-t>'] = { 'tab', mode = { 'i', 'n' } },
            -- ['<C-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
            ['<C-q>'] = { 'qflist', mode = { 'i', 'n' } },
          },
        },
        list = {
          keys = {
            ['<BS>'] = 'explorer_up',
            ['\\'] = 'explorer_up',
            ['l'] = 'confirm',
            ['o'] = false,
            ['h'] = 'explorer_close',
            ['a'] = 'explorer_add',
            ['d'] = 'explorer_del',
            ['D'] = 'git_rm',
            ['r'] = 'explorer_rename',
            ['p'] = 'toggle_preview',
            ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
            ['<C-g>'] = 'cancel',
            ['<C-s>'] = 'split',
            ['<C-t>'] = 'tab',
            ['<C-v>'] = 'vsplit',
            ['<A-w>'] = false,
          },
        },
      },
    }, -- }}}4
    files = {
      cmd = 'fd',
      hidden = true,
      ignored = true,
      support_live = false,
      exclude = EXCLUED_FILES,
    },
    kensaku = {
      format = 'file',
      regex = true,
      show_empty = false,
      live = true,
      support_live = true,
      exclude = EXCLUED_FILES,
    },
    mru = {
      layout = 'vscode',
    },
    registers = {
      layout = 'registers',
      actions = {
        reg_delete = function(picker)
          picker.preview:reset()
          local items = picker:selected({ fallback = true })
          for _, item in ipairs(items) do
            vim.fn.setreg(item.reg, vim.empty_dict())
          end
          picker.list:set_selected()
          picker.list:set_target()
          picker:find()
          vim.cmd.wshada({ bang = true })
        end,
      },
      win = {
        input = {
          keys = {
            ['D'] = { 'reg_delete', mode = { 'i', 'n' } },
          },
        },
        list = {
          keys = { ['D'] = 'reg_delete' },
        },
      },
    },
  }, -- }}}3
  toggles = { -- {{{3
    follow = 'f',
    hidden = 'h',
    ignored = 'i',
    modified = 'm',
    regex = { icon = 'R', value = false },
  }, -- }}}3
  icons = { -- {{{3
    ui = {
      hidden = 'h',
      ignored = 'i',
      follow = 'f',
      selected = '',
      -- selected = '●',
      -- unselected = '○',
    },
    git = {
      enabled = true,
      commit = '󰜘',
      staged = '●',
      added = 'A ',
      deleted = 'D ',
      ignored = '',
      modified = '○',
      renamed = 'R ',
      unmerged = '? ',
      untracked = '? ',
    },
    diagnostics = symbol.disgnostics,
    lsp = {
      unavailable = '',
      enabled = ' ',
      disabled = ' ',
      attached = '󰖩 ',
    },
    kinds = require('tartar.icon.kind'),
  }, --}}}3
  db = { sqlite3_path = nil },
  debug = { -- {{{3
    scores = false, -- show scores in the list
    leaks = false, -- show when pickers don't get garbage collected
    explorer = false, -- show explorer debug info
    files = false, -- show file debug info
    grep = false, -- show file debug info
    proc = false, -- show proc debug info
    extmarks = false, -- show extmarks errors
  }, -- }}}3
} -- }}}2
local style_opts = { -- {{{2
  float = {
    position = 'float',
    backdrop = false,
    height = 0.8,
    width = 0.8,
    zindex = 50,
    wo = { winhighlight = 'NormalFloat:Normal' },
  },
  help = {
    border = 'single',
    position = 'float',
    backdrop = false,
    row = -1,
    width = 0,
    height = 0.3,
  },
  input = {
    backdrop = false,
    position = 'float',
    border = 'double',
    title_pos = 'center',
    height = 1,
    width = 60,
    relative = 'editor',
    noautocmd = false,
    row = 2,
    wo = {
      winhighlight = 'NormalFloat:Normal',
      cursorline = false,
    },
    bo = {
      filetype = 'snacks_input',
      buftype = 'prompt',
    },
    --- buffer local variables
    b = {
      completion = false, -- disable blink completions in input
    },
  },
  minimal = {
    wo = {
      cursorcolumn = false,
      cursorline = false,
      cursorlineopt = 'both',
      colorcolumn = '',
      fillchars = 'eob: ,lastline:…',
      list = false,
      listchars = 'extends:…,tab:  ',
      number = false,
      relativenumber = false,
      signcolumn = 'no',
      spell = false,
      winbar = '',
      statuscolumn = '',
      wrap = false,
      sidescrolloff = 0,
    },
  },
  notification = {
    border = 'single',
    zindex = 100,
    ft = 'markdown',
    wo = {
      winblend = 5,
      wrap = false,
      conceallevel = 2,
      colorcolumn = '',
    },
    bo = { filetype = 'snacks_notif' },
  },
  notification_history = {
    fixbuf = true,
    border = 'single',
    zindex = 100,
    width = 0.8,
    height = 0.8,
    minimal = false,
    title = ' Notification History ',
    title_pos = 'center',
    ft = 'markdown',
    bo = { modifiable = false },
    wo = { winhighlight = 'Normal:@markup.raw,FloatTitle:Normal' },
    keys = { q = 'close' },
  },
} -- }}}2
local win_opts = { -- {{{2
  backdrop = false,
  show = true,
  fixbuf = true,
  relative = 'editor',
  position = 'float',
  minimal = true,
  wo = {
    winhighlight = 'Normal:StabaNormal',
  },
  keys = { q = 'close' },
} -- }}}2

return {
  'folke/snacks.nvim',
  priority = 999,
  lazy = false,
  init = function() -- {{{2
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        local sources = require('snacks.picker.config.sources')
        sources.kensaku = require('plugin.source.snacks_kensaku')
        sources.mru = require('plugin.source.snacks_mru')
        vim.api.nvim_create_user_command('R', function(opts)
          local full_path = vim.api.nvim_buf_get_name(0)
          local dir_path = vim.fs.dirname(full_path)
          Snacks.rename.rename_file({
            from = full_path,
            to = vim.fs.joinpath(dir_path, opts.args),
          })
        end, { nargs = '?', desc = 'Rename File' })
        -- local _fast_event_wrap = require('tartar.helper').fast_event_wrap
        -- local notify = Snacks.notifier.notify
        ---@diagnostic disable: duplicate-set-field
        -- vim.print = function(...)
        --   local info, lines = require('helper').inspect(1000, ...)
        --   _fast_event_wrap(notify)(lines, vim.log.levels.TRACE, { title = info })
        -- end
        -- print = function(...)
        --   local msg = 'nil'
        --   if ... then
        --     msg = vim
        --       .iter({ ... })
        --       :map(function(v)
        --         local s = tostring(v):gsub('\\n', '\n')
        --         return s
        --       end)
        --       :join(' ')
        --   end
        --   _fast_event_wrap(notify)(msg, vim.log.levels.TRACE, { title = 'print' })
        -- end
        Snacks.toggle.profiler():map('<leader><Leader>p')
        -- Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<Leader><Leader>w')
        -- Snacks.toggle.option('shellslash', { name = 'Shellslash' }):map('<Leader><Leader>/')
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map('<Leader><Leader>c')
        Snacks.toggle.inlay_hints():map('gli')
        Snacks.toggle.diagnostics():map('gld')
      end,
    })
  end, -- }}}2
  opts = { -- {{{2
    bigfile = bigfile_opts,
    -- notifier = notifier_opts,
    picker = picker_opts,
    quickfile = { enabled = true },
    win = win_opts,
    styles = style_opts,
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- image = image_opts,
    -- indent = { enabled = true },
    -- input = input_opts,
    -- scope = { enabled = true },
    -- scratch = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  }, -- }}}2
  keys = { -- {{{2
    -- {
    --   'ms',
    --   function()
    --     Snacks.notifier.show_history({ reverse = true })
    --   end,
    --   desc = 'Show notifications',
    -- },
    {
      '<Leader><Leader><Leader>',
      function()
        Snacks.notifier.hide()
        local mod = package.loaded['fidget']
        if mod then
          mod.notification.clear()
        end
      end,
      desc = 'Hide notifications',
    },
    {
      '<Leader>:',
      function()
        Snacks.picker.buffers({
          layout = { preset = 'default' },
        })
      end,
      desc = 'Buffers',
    },
    {
      '<Leader>@',
      function()
        Snacks.picker.files({
          cwd = vim.fn.stdpath('config'),
          layout = 'vscode',
        })
      end,
      desc = 'Find Config File',
    },
    {
      '<Leader>o',
      function()
        Snacks.picker.explorer({
          cwd = vim.fs.root(0, '.git'),
        })
      end,
    },
    {
      '<Leader>p',
      function()
        Snacks.picker.files({
          cwd = vim.api.nvim_buf_get_name(0):gsub('[^\\/]*$', ''),
          layout = 'vscode',
        })
      end,
      desc = 'Files',
    },
    {
      '<Leader>z',
      function()
        local opts = {
          prompt = 'zoxide query: ',
        }
        vim.ui.input(opts, function(input)
          if input and input ~= '' then
            vim.system({ 'zoxide', 'add', input }, { text = true })
            vim.system({ 'zoxide', 'query', input }, { text = true }, function(data)
              vim.schedule(function()
                if data.code == 0 and data.stdout then
                  Snacks.picker.explorer({
                    cwd = data.stdout:gsub('\n', ''),
                  })
                else
                  vim.notify('zoxide: no match found', 3)
                end
              end)
            end)
          end
        end)
      end,
      desc = 'Zoxide',
    },
    {
      '<Leader>k',
      function()
        local is_help = vim.bo.filetype == 'help'
        local cwd = is_help and vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.uv.cwd()
        Snacks.picker.kensaku({
          cwd = cwd,
        })
      end,
      desc = 'Kensaku',
    },
    {
      '<Leader>m',
      function()
        Snacks.picker.mru()
      end,
      desc = 'vim-mr mru',
    },
    {
      '<Leader>h',
      function()
        Snacks.picker.help({
          layout = { preset = 'dropdown' },
          confirm = 'help',
        })
      end,
      desc = 'Help Pages',
    },
    {
      '<Space>/',
      function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        require('staba').wrap_no_fade_background(Snacks.picker.lines, {
          focus = 'list',
          pattern = vim.fn.expand('<cword>'),
          matcher = { fuzzy = false, smartcase = true, ignorecase = true, sort_empty = false },
          layout = {
            preset = 'ivy_split',
            layout = {
              preview = 'main',
              box = 'vertical',
              backdrop = false,
              width = 0,
              height = 0.3,
              position = 'bottom',
              border = 'none',
              {
                box = 'horizontal',
                { win = 'list', border = 'none' },
                { win = 'preview', width = 0.6, border = 'none' },
              },
            },
          },
          on_show = function(picker)
            for i, item in ipairs(picker:items()) do
              if item.idx == row then
                picker.list:view(i)
                Snacks.picker.actions.list_scroll_center(picker)
                break
              end
            end
          end,
        })
      end,
      desc = 'Lines',
    },
    -- git
    {
      '<Leader>gb',
      function()
        Snacks.picker.git_branches({
          layout = { preset = 'dropdown' },
          win = {
            list = {
              keys = { ['<c-x>'] = 'git_branch_del' },
            },
          },
        })
      end,
      desc = 'Git Branches',
    },
    {
      '<Leader>gd',
      function()
        Snacks.picker.git_diff({
          live = false,
        })
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<Leader>gl',
      function()
        Snacks.picker.git_log({
          layout = { preset = 'sideview' },
        })
      end,
      desc = 'Git Log',
    },
    {
      '<Leader>gs',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<Leader>ss',
      function()
        Snacks.picker()
      end,
      desc = 'Pickers',
    },
    {
      '<Leader>sr',
      function()
        Snacks.picker.registers({
          confirm = function(picker, item)
            picker:close()
            vim.api.nvim_set_current_win(picker.finder.filter.current_win)
            if item then
              vim.api.nvim_input('"' .. item.reg)
            end
          end,
        })
      end,
      desc = 'Registers normal-mode',
    },
    {
      '<C-r>r',
      function()
        Snacks.picker.registers({
          confirm = function(picker, item)
            picker:close()
            vim.api.nvim_set_current_win(picker.finder.filter.current_win)
            if item then
              vim.api.nvim_paste(item.data, true, -1)
              vim.api.nvim_input('a')
            end
          end,
        })
      end,
      desc = 'Registers insert-mode',
      mode = { 'i' },
    },
    {
      '<Leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<Leader>sh',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<Leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<Leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<Leader>sl',
      function()
        Snacks.picker.lazy()
      end,
      desc = 'Search for Plugin Spec',
    },
    {
      '<Leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<Leader>sc',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    {
      'gls',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      'glx',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
    {
      '<Leader>N',
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          backdrop = 80,
          width = 0.8,
          height = 0.8,
          wo = {
            conceallevel = 3,
            signcolumn = 'auto',
            statuscolumn = ' ',
            spell = false,
            winblend = 0,
            wrap = false,
          },
        })
      end,
      desc = 'Neovim News',
    },
    {
      '<Leader><Leader>t',
      function()
        local et = vim.bo.expandtab and 'set noexpandtab' or 'set expandtab'
        vim.cmd(et .. '|retab')
        vim.notify(et, vim.log.levels.INFO, { 'Options' })
      end,
      desc = 'Expandtab',
      mode = { 'n' },
    },
    -- {
    --   ']]',
    --   function()
    --     Snacks.words.jump(vim.v.count1)
    --   end,
    --   desc = 'Next Reference',
    --   mode = { 'n', 't' },
    -- },
    -- {
    --   '[[',
    --   function()
    --     Snacks.words.jump(-vim.v.count1)
    --   end,
    --   desc = 'Prev Reference',
    --   mode = { 'n', 't' },
    -- },
  }, -- }}}2
}
