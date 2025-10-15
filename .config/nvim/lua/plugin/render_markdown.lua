return {
  'MeanderingProgrammer/markdown.nvim',
  name = 'render-markdown',
  lazy = true,
  ft = { 'markdown', 'codecompanion' },
  keys = {
    { '<C-t>', '<Cmd>RenderMarkdown toggle<CR>', { desc = 'RenderMarkdown toggle' } },
  },
  opts = {
    enabled = true,
    render_modes = { 'n', 'c', 't' },
    sign = { enabled = false },
    debounce = 200,
    preset = 'obsidian',
    file_types = { 'markdown', 'codecompanion' },
    completions = { lsp = { enabled = true } },
    bullet = { enabled = true, icons = { '', '', '', '' } },
    checkbox = {
      enabled = true,
      unchecked = { icon = '󰄱', highlight = '@markup.list.unchecked' },
      checked = { icon = '󰱒', highlight = '@markup.list.unchecked' },
      custom = { todo = { raw = '[-]', rendered = '󰥔 ', highlight = '@markup.link' } },
    },
    anti_conceal = {
      enabled = false,
    },
    -- on = {
    --   attach = function()
    --     if vim.bo.filetype == 'codecompanion' then
    --       vim.cmd.RenderMarkdown('enable')
    --     end
    --   end,
    --   -- render = function()
    --   --   if vim.bo.filetype == 'codecompanion' then
    --   --     require('render-markdown.core.manager').set_current(true)
    --   --   end
    --   -- end,
    -- },
    heading = {
      enabled = true,
      render_modes = false,
      sign = false,
      icons = function()
        return ''
      end,
      position = 'inline',
      width = 'block',
      left_pad = 1,
      min_width = 80,
    },
    code = {
      enabled = true,
      render_modes = false,
      sign = false,
      width = 'block',
      left_pad = 1,
      min_width = 80,
    },
    win_options = {
      concealcursor = { default = vim.api.nvim_get_option_value('concealcursor', {}), rendered = 'n' },
    },
  },
}
