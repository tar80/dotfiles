local white = '#FFFFFF'
local silver = '#DDEEFF'
local gray = '#BBCCDD'
local slate = '#778899'
local blue = '#33AAFF'
local navy = '#445588'

return {
  cursor = { fg = white, bg = blue },
  selection = { fg = silver, bg = navy },
  menu = { fg = gray, bg = navy },
  gradient = { '#001000', '#302b43', '#24243e' },
  tab = {
    simple = { active = '#AADD22', noactive = '#558866' },
    deco = { active = { fg = blue, bg = '#FFFFFF' }, noactive = { fg = navy, bg = gray } },
  },
  status = {
    mode = { fg = { Color = silver }, bg = { Color = 'NONE' } },
    workspace = { fg = { Color = slate }, bg = { Color = 'NONE' } },
  },
}
