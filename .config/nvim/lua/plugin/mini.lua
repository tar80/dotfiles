-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

return {
  {-- {{{2 icons
    'nvim-mini/mini.icons',
    priority = 1001,
    lazy = true,
    config = function()
      require('mini.icons').setup()
      require('mini.icons').mock_nvim_web_devicons()
    end,
  },-- }}}
  {-- {{{2 diff
    'nvim-mini/mini.diff',
    config = function()
      local diff = require('mini.diff')
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
        view = {
          style = 'sign',
          -- signs = { add = '▒', change = '▒', delete = '▒' },
          -- signs = { add = '▍', change = '▍', delete = '▍' },
          signs = { add = '⣿', change = '⣿', delete = '⣿' },
          priority = 10,
        },
        delay = { text_change = 2000 },
        mappings = {
          --   apply = 'gsa',
          --   reset = '',
          --   textobject = '',
          --   goto_first = '[C',
          --   goto_prev = '[c',
          --   goto_next = ']c',
          --   goto_last = ']C',
        },
        options = {
          algorithm = 'histogram',
          indent_heuristic = true,
          linematch = 60,
          wrap_goto = false,
        },
      })
    end,
  },-- }}}
}
