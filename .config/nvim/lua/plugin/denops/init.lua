-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local helper = require('helper')

return {
  {
    'vim-denops/denops.vim',
    priority = 500,
    event = 'BufEnter',
    dependencies = { 'lambdalisue/kensaku.vim', lazy = true },
    init = function()
      vim.api.nvim_set_var('denops_disable_version_check', 1)
      vim.api.nvim_set_var('denops#deno', helper.scoop_apps('apps/deno/current/deno.exe'))
      vim.api.nvim_set_var('denops#server#deno_args', { '-q', '--no-lock', '--unstable-kv', '-A' })
      vim.api.nvim_set_var('denops#server#retry_threshold', 1)
      vim.api.nvim_set_var('denops#server#reconnect_threshold', 1)

      vim.api.nvim_set_var('kensaku_dictionary_cache',os.getenv('XDG_CACHE_HOME')..'kensaku.vim/migemo-compact-dict')
    end,
  },
}
