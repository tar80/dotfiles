-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local helper = require('helper')
local api = vim.api

return {
  {
    'vim-denops/denops.vim',
    priority = 500,
    event = 'VeryLazy',
    dependencies = { 'lambdalisue/kensaku.vim', lazy = true },
    init = function()
      api.nvim_set_var('denops_disable_version_check', 1)
      api.nvim_set_var('denops#deno', helper.scoop_apps('apps/deno/current/deno.exe'))
      api.nvim_set_var('denops#server#deno_args', { '-q', '--no-lock', '--unstable-kv', '-A' })
      api.nvim_set_var('denops#server#retry_threshold', 1)
      api.nvim_set_var('denops#server#reconnect_threshold', 1)
    end,
  },
}
