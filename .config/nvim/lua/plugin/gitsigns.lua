-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local api = vim.api
local helper = require('helper')

return {
  'lewis6991/gitsigns.nvim',
  keys = {
    {
      'gss',
      function()
        require('gitsigns').attach(api.nvim_get_current_buf())
      end,
      desc = 'Attach gitsigns',
    },
  },
  opts = {
    signs_staged = {
      add = { text = '+' },
      change = { text = '+' },
      delete = { text = '-' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged_enable = true,
    auto_attach = false,
    culhl = true,
    update_debounce = vim.g.update_time,
    word_diff = true,
    trouble = true,
    diff_opts = {
      algorithm = 'histogram',
      internal = true,
      indent_heuristic = true,
      vertical = true,
      linematch = 1,
      ignore_whitespace = false,
      ignore_whitespace_change_at_eol = true,
    },
    preview_config = { border = 'rounded' },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      -- Navigation
      helper.buf_setmap(bufnr, 'n', ']c', 'callback', {
        callback = function()
          if vim.wo.diff then
            return ']c'
          end
          gs.nav_hunk('next', { foldopen = true, preview = true }, function()
            vim.api.nvim_input('zz')
          end)
          return '<Ignore>'
        end,
        desc = 'Go to next hunk',
        expr = true,
      })
      helper.buf_setmap(bufnr, 'n', '[c', 'callback', {
        callback = function()
          if vim.wo.diff then
            return '[c'
          end
          gs.nav_hunk('prev', { foldopen = true, preview = true }, function()
            vim.api.nvim_input('zz')
          end)
          return '<Ignore>'
        end,
        desc = 'Go to previous hunk',
        expr = true,
      })
      -- Actions
      helper.buf_setmap(bufnr, { 'n', 'x' }, 'gsa', 'callback', {
        callback = function()
          local mode = api.nvim_get_mode().mode
          local range = mode:find('[vV]') == 1 and { vim.fn.line('v'), api.nvim_win_get_cursor(0)[1] } or nil
          gs.stage_hunk(range)
        end,
        desc = 'Stage the hunk',
      })
      helper.buf_setmap(bufnr, { 'n', 'x' }, 'gsr', gs.undo_stage_hunk, { desc = 'Undo the hunk' })
      helper.buf_setmap(bufnr, 'n', 'gsR', gs.reset_buffer, { desc = 'Reset the buffer' })
      helper.buf_setmap(bufnr, 'n', 'gsp', gs.preview_hunk, { desc = 'Preview the hunk' })
      helper.buf_setmap(bufnr, 'n', 'gsb', 'callback', {
        callback = function()
          gs.blame_line({ full = true })
        end,
        desc = 'Blame a line',
      })
      helper.buf_setmap(bufnr, 'n', 'gsv', gs.select_hunk, { desc = 'Select the hunk' })
      helper.buf_setmap(bufnr, 'n', 'gsq', gs.setloclist, { desc = 'Open the loclist' })
      helper.buf_setmap(bufnr, 'n', 'gsS', 'callback', {
        callback = function()
          require('gitsigns').detach(bufnr)
          if vim.fn.maparg('gsa', 'n') ~= '' then
            api.nvim_buf_del_keymap(0, 'n', 'gsa')
            api.nvim_buf_del_keymap(0, 'x', 'gsa')
            api.nvim_buf_del_keymap(0, 'n', 'gsr')
            api.nvim_buf_del_keymap(0, 'x', 'gsr')
            api.nvim_buf_del_keymap(0, 'n', 'gsR')
            api.nvim_buf_del_keymap(0, 'n', 'gsp')
            api.nvim_buf_del_keymap(0, 'n', 'gsb')
            api.nvim_buf_del_keymap(0, 'n', 'gsq')
            api.nvim_buf_del_keymap(0, 'n', 'gsv')
            api.nvim_buf_del_keymap(0, 'n', 'gsS')
            api.nvim_buf_del_keymap(0, 'n', '[c')
            api.nvim_buf_del_keymap(0, 'n', ']c')
          end
        end,
        desc = 'Detach gitsigns',
      })
    end,
  },
}
