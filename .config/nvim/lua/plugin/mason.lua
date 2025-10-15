-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

local icon = require('tartar.icon.symbol')

return {
  'williamboman/mason.nvim',
  lazy = true,
  cmd = 'Mason',
  opts = {
    ui = {
      -- border = FLOAT_BORDER,
      icons = {
        package_installed = icon.status.done,
        package_pending = icon.status.pending,
        package_uninstalled = icon.status.missing,
      },
      keymaps = { apply_language_filter = '<NOP>' },
    },
    -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },
    pip = { install_args = {} },
    -- log_level = vim.log.levels.INFO,
    -- max_concurrent_installers = 4,
    github = {},
  },
}
