-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local light_theme = 'vivid'
local dark_theme = 'chill'
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
  local time = require('helper').adapt_time(6, 18)
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
        return tr and {}
          or {
            light = {
              -- ['@type.luadoc'] = { style = 'dim,italic' },
              FidgetInfo = { fg = colors.olive, style = 'blink' },
              MsgArea = { bg = '#F2F0EE' },
              CursorLineHold = { bg = '#FDE3DD' },
              SelectorLabel = { bg = colors.high_cyan, fg = colors.bg, style = 'bold' },
              BlinkCmpSignatureHelpActiveParameter = { sp = colors.high_cyan, style = 'underline,bold' },
              BlinkCmpSignatureHelp = { bg = colors.selection },
              BlinkCmpSignatureHelpBorder = { fg = colors.selection },
              -- BlinkCmpDoc = { fg = colors.fg, bg = colors.shade_blue },
              -- BlinkCmpDocSeparator = { fg = colors.gray, bg = colors.shade_blue },
            },
            dark = {
              -- ['@type.luadoc'] = { style = 'dim,italic' },
              FidgetInfo = { fg = colors.olive, style = 'blink' },
              MsgArea = { bg = '#102025' },
              CursorLineHold = { bg = '#3E1D31' },
              SelectorLabel = { bg = colors.high_cyan, fg = colors.bg, style = 'bold' },
              BlinkCmpSignatureHelpActiveParameter = { sp = colors.high_cyan, style = 'underline,bold' },
              BlinkCmpSignatureHelp = { bg = colors.shade_cyan },
              BlinkCmpSignatureHelpBorder = { fg = colors.shade_cyan },
              -- BlinkCmpDoc = { fg = colors.fg, bg = colors.shade_blue },
              -- BlinkCmpDocSeparator = { fg = colors.gray, bg = colors.shade_blue },
            },
          }
      end,
      integrations = {
        editor = true,
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
        render_markdown = true,
        rereope = true,
        sandwich = true,
        -- skkeleton_henkan_highlight = true,
        -- skkeleton_indicator = false,
        snacks = true,
        staba = true,
        trouble = true,
      },
    },
  },
}
