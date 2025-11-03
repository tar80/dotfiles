-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local helper = require('helper')
local bubble = require('tartar.icon.ui').frame.arrow
local bubble_border = require('tartar.helper').generate_decorative_line(bubble.left, bubble.right, 'SkkeletonHenkanBorder')

-- local piyo = string.char(0xF0, 0x9F, 0x90, 0xA4)

local skkeleton_init = function() -- {{{2
  local mapped_keys = vim.g['skkeleton#mapped_keys']
  vim.list_extend(mapped_keys, { '<C-i>' })
  vim.g['skkeleton#mapped_keys'] = mapped_keys
  vim.fn['skkeleton#config']({
    databasePath = '~/.skk/db/jisyo.db',
    globalDictionaries = { '~/.skk/SKK-JISYO.L.yaml' },
    globalKanaTableFiles = { helper.xdg_path('config', 'skk/azik_us.rule') },
    eggLikeNewline = true,
    showCandidatesCount = 2,
    markerHenkan = '',
    markerHenkanSelect = '',
    -- markerHenkan = '🐤',
    -- markerHenkanSelect = '🐥',
    sources = { 'deno_kv' },
    -- sources = { 'deno_kv', 'skk_dictionary' },
  })
  vim.fn['skkeleton#register_keymap']('input', ';', 'henkanPoint')
  vim.fn['skkeleton#register_keymap']('input', '<C-i>', 'katakana')
  vim.fn['skkeleton#register_keymap']('input', '@', 'cancel')
  vim.fn['skkeleton#register_keymap']('henkan', '@', 'cancel')
  vim.fn['skkeleton#register_keymap']('input', '<Up>', 'disable')
  vim.fn['skkeleton#register_keymap']('input', '<Down>', 'disable')
  vim.fn['skkeleton#register_kanatable']('rom', {
    [':'] = { 'っ', '' },
    ['xq'] = 'hankatakana',
    ['vh'] = { '←', '' },
    ['vj'] = { '↓', '' },
    ['vk'] = { '↑', '' },
    ['vl'] = { '→', '' },
    ['z\x20'] = { '\u{3000}', '' },
    ['z-'] = { '-', '' },
    ['z~'] = { '〜', '' },
    ['z;'] = { ';', '' },
    ['z:'] = { ':', '' },
    ['z,'] = { ',', '' },
    ['z.'] = { '.', '' },
    ['z['] = { '【', '' },
    ['z]'] = { '】', '' },
  })
end --}}}

return {
  { -- {{{2 skkeleton
    'vim-skk/skkeleton',
    dependencies = {
      'NI57721/skkeleton-henkan-highlight',
      {-- {{{2 state-popup
        'NI57721/skkeleton-state-popup',
        config = function()
          vim.fn['skkeleton_state_popup#config']({
            labels = {
              input = {
                hira = ' 󱌴 ',
                kata = ' 󱌵 ',
                hankata = ' 󱌶 ',
                zenkaku = ' 󰚞 ',
              },
              ['input:okurinasi'] = {
                hira = '▽󱌴 ',
                kata = '▽󱌵 ',
                hankata = '▽󱌶 ',
                zenkaku = '▽󰚞 ',
                abbrevText = ' 󱌯 ',
              },
              ['input:okuriari'] = {
                hira = '▽󱌴 ',
                kata = '▽󱌵 ',
                hankata = '▽󱌶 ',
                zenkaku = '▽󰚞 ',
              },
              henkan = {
                hira = '▼󱌴 ',
                kata = '▼󱌵 ',
                hankata = '▼󱌶 ',
                zenkaku = '▼󰚞 ',
                abbrevText = ' 󱌯 ',
              },
              latin = '_A ',
            },
            opts = { relative = 'cursor', col = 0, row = 1, anchor = 'NW', style = 'minimal', border = bubble_border},
          })
          vim.cmd([[call skkeleton_state_popup#run()]])
        end,
      },-- }}}
    },
    config = function()
      local augroup = vim.api.nvim_create_augroup('rc_skkeleton', { clear = true })
      ---@desc Autocommand
      vim.api.nvim_create_autocmd('User', {
        group = augroup,
        pattern = 'skkeleton-initialize-pre',
        callback = skkeleton_init,
      })

      ---@desc Keymaps {{{3
      -- vim.keymap.set({ 'i', 'c', 't' }, '<C-l>', '<Plug>(skkeleton-enable)')
      vim.keymap.set({ 'i', 'c', 't' }, '<F14>', '<Plug>(skkeleton-enable)')
      vim.keymap.set({ 'i', 'c', 't' }, '<F15>', '<Plug>(skkeleton-disable)')
      vim.keymap.set({ 'n' }, '<Space>i', 'i<Plug>(skkeleton-enable)')
      vim.keymap.set({ 'n' }, '<Space>I', 'I<Plug>(skkeleton-enable)')
      vim.keymap.set({ 'n' }, '<Space>a', 'a<Plug>(skkeleton-enable)')
      vim.keymap.set({ 'n' }, '<Space>A', 'A<Plug>(skkeleton-enable)')
      -- }}}
    end,
  }, --}}}
  -- { -- {{{2 skkeleton_indicator
  --   'delphinus/skkeleton_indicator.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     alwaysShown = false,
  --     fadeOutMs = 0,
  --     hiraText = ' 󱌴 ',
  --     kataText = ' 󱌵 ',
  --     hankataText = ' 󱌶 ',
  --     zenkakuText = ' 󰚞 ',
  --     abbrevText = ' 󱌯 ',
  --     row = 1,
  --     border = 'none',
  --     -- border = function()
  --     --   return { '', '', '', '┃', '', '', '', '┃' }
  --     -- end,
  --     -- useDefaultHighlight = false,
  --   },
  -- }, -- }}}
}
