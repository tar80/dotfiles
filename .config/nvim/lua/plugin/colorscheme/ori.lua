-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local light_theme = 'muted'
local dark_theme = 'mallow'
local transparent = {}

---Transparent background
---@type boolean|nil
local tr = vim.g.tr_bg
if tr then
  vim.o.winblend = 0
  light_theme = 'glass'
  dark_theme = 'glass'
  transparent =
    { 'Normal', 'NormalNC', 'NormalFloat', 'LineNr', 'SignColumn', 'FloatBorder', 'FloatTitle', 'FloatFooter' }
end

---@type string, string, string
local global_bg = (function()
  local time = require('helper').adapt_time(7, 18)
  return time == 'daytime' and 'light' or 'dark'
end)()

return {
  {
    'tar80/ori.nvim',
    dev = true,
    lazy = false,
    priority = 999,
    opts = {
      enable_usercmd = true,
      background = global_bg,
      theme = { light = light_theme, dark = dark_theme },
      fade_nc = false,
      transparent = transparent,
      styles = {
        comments = 'italic',
        deprecated = 'NONE',
        diagnostics = 'undercurl',
        functions = 'NONE',
        keywords = 'bold',
        references = 'NONE',
        spell = 'undercurl,italic',
        strings = 'NONE',
        variables = 'NONE',
        virtualtext = 'italic',
      },
      disable = {
        background = tr,
        eob_lines = true,
        -- cursorline = true,
        statusline = true,
        tabline = true,
      },
      custom_highlights = function(opts, colors)
        return tr and {} or {
          light = {
            MsgArea = { bg = '#F2FBE9' },
            CursorLineHold = { fg = 'NONE', bg = '#FDE3DD' },
            BlinkCmpSignatureHelp = { bg = colors.diff_change },
            BlinkCmpSignatureHelpBorder = { fg = colors.diff_change },
          },
          dark = {
            MsgArea = { bg = '#102025' },
            CursorLineHold = { fg = 'NONE', bg = '#3E1D31' },
            BlinkCmpSignatureHelp = { bg = colors.diff_change },
            BlinkCmpSignatureHelpBorder = { fg = colors.diff_change },
          },
        }
      end,
      integrations = {
        quicker = true,
        nightly = true,
        lazy = true,
        -- codecompanion = true,
        blink = true,
        dap = true,
        dap_virtual_text = true,
        flash = true,
        fret = true,
        gitsigns = true,
        matchwith = true,
        mini_diff = true,
        mini_icons = true,
        -- nvim_treesitter = true,
        render_markdown = true,
        rereope = true,
        sandwich = true,
        skkeleton_indicator = true,
        snacks = true,
        staba = true,
        trouble = true,
      },
    },
  },
}
