-- workspace=D:/Home/.local/share/nvim-data/lazy/flash.nvim/lua/flash
-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local beacon = (function()
  local ok, beacon = pcall(require, 'tartar.beacon')
  if ok then
    return beacon.new('FlashLabel', 80, 30, 15)
  end
end)()

local NORMAL_LABELS = 'asdfgtrewqhjkluiopnmbvcxz'
local SEARCH_LABELS = '*nNasdfglkjhqwertgbvcxzpoiuym'

return {
  'folke/flash.nvim',
  enabled = true,
  opts = {
    labels = NORMAL_LABELS,
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
      mode = 'exact',
      incremental = false,
      exclude = {
        'flash_prompt',
        function(win)
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
      trigger = '',
      max_length = false, ---@type number|false
    },
    jump = {
      jumplist = true,
      pos = 'start',
      history = false,
      register = false,
      nohlsearch = false,
      autojump = false,
      -- You can force inclusive/exclusive jumps by setting the
      -- `inclusive` option. By default it will be automatically
      -- set based on the mode.
      inclusive = nil, ---@type boolean?
      -- jump position offset. Not used for range jumps.
      -- 0: default
      -- 1: when pos == "end" and pos < current position
      offset = nil, ---@type number
    },
    label = {
      uppercase = false,
      exclude = '',
      current = true,
      after = false, ---@type boolean|number[]
      -- show the label before the match
      before = true, ---@type boolean|number[]
      -- position of the label extmark
      style = 'overlay', ---@type "eol" | "overlay" | "right_align" | "inline"
      reuse = 'lowercase', ---@type "lowercase" | "all" | "none"
      -- for the current window, label targets closer to the cursor first
      distance = true,
      min_pattern_length = 0,
      rainbow = {
        enabled = false,
        -- number between 1 and 9
        shade = 5,
      },
      -- With `format`, you can change how the label is rendered.
      -- Should return a list of `[text, highlight]` tuples.
      ---@type fun(opts:Flash.Format): string[][]
      format = function(opts)
        return { { opts.match.label, opts.hl_group } }
      end,
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = true,
      -- Highlight the search matches
      matches = true,
      -- extmark priority
      priority = 5000,
      groups = {
        match = 'FlashMatch',
        current = 'FlashCurrent',
        backdrop = 'FlashBackdrop',
        label = 'FlashLabel',
      },
    },
    -- action to perform when picking a label.
    -- defaults to the jumping logic depending on the mode.
    ---@type fun(match:Flash.Match, state:Flash.State)|nil
    action = nil,
    -- initial pattern to use when opening flash
    pattern = '',
    continue = false,
    -- Set config to a function to dynamically change the config
    config = nil, ---@type fun(opts:Flash.Config)|nil
    -- You can override the default options for a specific mode.
    -- Use it with `require("flash").jump({mode = "forward"})`
    ---@type table<string, Flash.Config>
    modes = {
      search = {
        enabled = false,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = false },
        label = { after = true, before = false },
        labels = SEARCH_LABELS,
        search = {
          multi_window = false,
          forward = true,
          wrap = false,
          -- `forward` will be automatically set to the search direction
          -- `mode` is always set to `search`
          -- `incremental` is set to `true` when `incsearch` is enabled
        },
      },
      char = { enabled = false },
      treesitter = {
        -- labels = 'asdfgqwerthjklyuiopbvcxznm',
        jump = { pos = 'range', autojump = true },
        search = { incremental = false },
        label = { before = true, after = true, style = 'overlay' },
        highlight = { backdrop = false, matches = false },
      },
      treesitter_search = {
        jump = { pos = 'range' },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = false, style = 'overlay' },
      },
      -- options used for remote flash
      remote = {
        remote_op = { restore = true, motion = true },
      },
    },
    prompt = {
      enabled = false,
    },
    -- options for remote operator pending mode
    remote_op = {
      -- restore window views and cursor position
      -- after doing a remote operation
      restore = false,
      -- For `jump.pos = "range"`, this setting is ignored.
      -- `true`: always enter a new motion when doing a remote operation
      -- `false`: use the window's cursor position and jump target
      -- `nil`: act as `true` for remote windows, `false` for the current window
      motion = false,
    },
  },
  keys = {
    {
      '<leader>f',
      mode = { 'n', 'x', 'o' },
      function()
        local pre = vim.api.nvim_win_get_cursor(0)
        require('flash').jump({ search = { mode = 'exact' } })
        local post = vim.api.nvim_win_get_cursor(0)
        if beacon and not vim.deep_equal(pre, post) then
          beacon:around_cursor(0)
        end
      end,
      desc = 'Flash',
    },
    {
      '<Space>',
      mode = { 'x', 'o' },
      function()
        if type(vim.treesitter.get_node()) == 'userdata' then
          require('flash').treesitter()
        end
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = { 'o' },
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      'R',
      mode = { 'o' },
      function()
        if type(vim.treesitter.get_node()) == 'userdata' then
          vim.cmd.normal('ma')
          require('flash').treesitter_search({ remote_op = { restore = true, motion = false } })
          vim.defer_fn(function()
            vim.cmd.normal('g`a')
            vim.api.nvim_buf_del_mark(0, 'a')
          end, 0)
        end
      end,
      desc = 'Remote selection Flash',
    },
    -- {
    --   '<C-s>',
    --   mode = { 'c' },
    --   function()
    --     require('flash').toggle()
    --   end,
    --   desc = 'Toggle Flash Search',
    -- },
    {
      '*',
      mode = { 'n' },
      function()
        return "<Cmd>call v:lua.require('helper').search_star()<CR><Plug>(*)"
      end,
      expr = true,
      desc = 'Search star',
    },
    {
      'g*',
      mode = { 'n' },
      function()
        return "<Cmd>call v:lua.require('helper').search_star(v:true)<CR><Plug>(*)"
      end,
      expr = true,
      desc = 'Search star',
    },
    {
      '*',
      mode = { 'x' },
      function()
        return "<Cmd>call v:lua.require('helper').search_star(v:false,v:true)<CR><Plug>(*)"
      end,
      expr = true,
      desc = 'Search star',
    },
    {
      '<plug>(*)*',
      mode = { 'n', 'x' },
      function()
        require('flash').jump({
          labels = SEARCH_LABELS,
          pattern = vim.fn.getreg('/'),
          search = { mode = 'search' },
          label = { current = true, after = true, before = false },
          highlight = { backdrop = false, matches = false },
        })
      end,
      desc = 'Search star Flash',
    },
  },
}
