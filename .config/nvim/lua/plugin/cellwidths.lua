-- vim:textwidth=0:foldmethod=marker:foldlevel=2:

return {
  'delphinus/cellwidths.nvim',
  event = 'VeryLazy',
  opts = {
    -- log_level = "DEBUG",
    name = 'user/custom',
    fallback = function(cw)
      cw.add(0x203B, 2)
      cw.add({
        { 0x2035,0x2037, 2},
      })
    end,
  },
  build = function()
    require('cellwidths').remove()
  end,
}
