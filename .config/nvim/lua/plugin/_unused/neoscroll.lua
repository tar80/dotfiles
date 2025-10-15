return {
  'karb94/neoscroll.nvim',
  opts = {
    mappings = {},
    hide_cursor = false,
    performance_mode = false,
    -- telescope_scroll_opts = {duration = 250},
  },
  keys = {
    {
      '<C-d>',
      function()
        require('neoscroll').ctrl_d({ duration = 60, easing = 'quadratic' })
      end,
      mode = { 'n', 'x' },
      desc = 'Neoscroll half down',
    },
    {
      '<C-u>',
      function()
        require('neoscroll').ctrl_u({ duration = 60, easing = 'quadratic' })
      end,
      mode = { 'n', 'x' },
      desc = 'Neoscroll half up',
    },
    -- {
    --   '<C-e>',
    --   function()
    --     require('neoscroll').scroll(0.1, { move_cursor = false, duration = 200, easing = 'circular' })
    --   end,
    --   mode = { 'n', 'x' },
    --   desc = 'Neoscroll down',
    -- },
    -- {
    --   '<C-y>',
    --   function()
    --     require('neoscroll').scroll(-0.1, { move_cursor = false, duration = 200, easing = 'circular' })
    --   end,
    --   mode = { 'n', 'x' },
    --   desc = 'Neoscroll up',
    -- },
    -- {
    --   'zt',
    --   function()
    --     require('neoscroll').zt({ half_win_duration = 25, easing = 'quintic' })
    --   end,
    --   mode = { 'n', 'x' },
    --   desc = 'Neoscroll top',
    -- },
    -- {
    --   'zz',
    --   function()
    --     require('neoscroll').zz({ half_win_duration = 40, easing = 'quintic' })
    --   end,
    --   mode = { 'n', 'x' },
    --   desc = 'Neoscroll middle',
    -- },
    -- {
    --   'zb',
    --   function()
    --     require('neoscroll').zb({ half_win_duration = 25, easing = 'quintic' })
    --   end,
    --   mode = { 'n', 'x' },
    --   desc = 'Neoscroll bottom',
    -- },
  },
}
