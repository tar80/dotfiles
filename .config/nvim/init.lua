local helper = require('helper')
local sep = jit.os == 'Windows' and ';' or ':'

do
  local node_modules = ('%s/node_modules/.bin'):format(vim.fn.stdpath('config'))
  vim.env.PATH = ('%s%s%s'):format(vim.env.PATH, sep, node_modules)
  vim.env.MYVIMRC = vim.uv.fs_realpath(os.getenv('MYVIMRC'))
  vim.env.CC = 'gcc'
  vim.env.SSH_AUTH_SOCK = nil
  vim.g.dev = 'X:/nvim'
  vim.g.repo = 'D:/Repos/tar80'
  vim.g.colors_name = 'ori'
  vim.g.update_time = 500
  vim.g.loaded_man = true
  ---@desc Disable preset plugins
  -- vim.g.editorconfig = false
end

vim.cmd('language message C')

---@desc Configuration file level
---There are four modes: "trans", "minimal", "extended" and "test"
local level = vim.g.start_level
vim.g.start_level = nil

if level == 'minimal' then
  helper.unload_presets()
  require('config._minimal')
  local vcs_init = vim.g.dev .. '/vcs-init.nvim'
  vim.opt.runtimepath:append(vcs_init)
  require('vcs-init').setup({
    disable_builtins = { enable = false },
    diffmaps = { enable = false },
    jjdiff = {
      enable = true,
      -- previewer_height = 25,
      -- previewer_direction = 'below',
      -- diff_options = { algorithm = 'histogram', linematch = 60 },
    },
    colorscheme = { enable = false },
  })
elseif level == 'test' then
  helper.shell('bash')
  -- vim.opt.rtp:prepend(vim.g.dev .. '/tartar.nvim')
  -- require('config.private')
  -- require('config.option')
  -- require('config.keymap')
  -- require('config.command')
  -- require('config.next_version')
  require('config._test').setup()
else
  helper.set_client_server(100, level)
  helper.shell('nyagos')

  vim.g.tr_bg = level == 'trans'
  vim.opt.rtp:prepend(vim.g.dev .. '/tartar.nvim')

  require('config.private')
  require('config.option')
  require('config.keymap')
  require('config.command')
  require('config.next_version')
  require('config._common').setup()
  require('config.lsp')
end
