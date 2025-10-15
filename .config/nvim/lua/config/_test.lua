-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local api = vim.api
local opt = vim.opt
local o = vim.o
local keymap = vim.keymap
local helper = require('helper')

---@desc OPTIONS {{{2
o.guicursor = 'n:block,i-c-ci-ve:ver50,v-r-cr-o:hor50'
o.fileencodings = 'utf-8,cp932,euc-jp,utf-16le'
o.updatetime = vim.g.update_time
-- o.backup= false
o.swapfile = false
o.undofile = true
o.showtabline = 2
o.laststatus = 3
o.cmdheight = 0
o.number = true
o.ruler = false
-- o.numberwidth = 4
o.relativenumber = true
o.signcolumn = 'yes'
o.shiftwidth = 2
o.softtabstop = 2
o.shiftround = true
o.expandtab = true
o.virtualedit = 'block'
opt.wildmode = { 'longest:full', 'full' }
opt.wildoptions:remove({ 'tagfile' })
opt.spelllang:append({ 'cjk' })
o.keywordprg = ':help'
o.helplang = 'ja'
o.helpheight = 10
o.previewheight = 8
--}}}2
---@desc KEYMAPS
---@desc Normal {{{2
vim.g.mapleader = ';'

keymap.set('n', '<F12>', helper.toggle_wrap)
keymap.set('n', '<C-Z>', '<NOP>')
keymap.set('n', ',', function()
  if o.hlsearch then
    o.hlsearch = false
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
---Move buffer use <SPACE>
keymap.set('n', '<SPACE>', '<C-W>', { remap = true })
keymap.set('n', '<SPACE><SPACE>', '<C-W><C-W>')
keymap.set('n', '<Space>n', helper.scratch_buffer)
keymap.set('n', '<SPACE>c', '<Cmd>tabclose<CR>')

---@desc Insert & Command {{{2
keymap.set('i', '<C-j>', '<DOWN>')
keymap.set('i', '<C-k>', '<UP>')
keymap.set('i', '<C-f>', '<RIGHT>')
keymap.set('i', '<S-DELETE>', '<C-O>D')
keymap.set('!', '<C-b>', '<LEFT>')
keymap.set('!', '<C-q>u', '<C-R>=nr2char(0x)<LEFT>')
keymap.set('c', '<C-a>', '<HOME>')

---@desc Visual {{{2
---clipbord yank
keymap.set('v', '<C-insert>', '"*y')
keymap.set('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
keymap.set('x', '<', '<gv')
keymap.set('x', '>', '>gv')
--}}}2

---@desc Commands
---@desc "Z <filepath>" zoxide query
api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---@desc COLORSCHEME {{{1
-- vim.cmd('colorscheme habamax')
do -- {{{2 Bootstrap
  local lazypath = helper.xdg_path('data', 'lazy/lazy.nvim')
  if not vim.uv.fs_stat(lazypath) then
    local cmdline =
      { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
    vim.system(cmdline, { text = true }):wait()
  end
  vim.opt.rtp:prepend(lazypath)
end --}}}2

local options = { -- {{{2
  browser = ('%s/apps/qutebrowser/current/qutebrowser.exe'):format(vim.env.SCOOP),
  throttle = 60,
  change_detection = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = vim.g.dev,
    patterns = { 'tar80' },
    fallback = false,
  },
  diff = {
    cmd = 'git',
  },
  install = {
    missing = false,
    colorscheme = { vim.g.colors_name },
  },
  readme = {
    enabled = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  pkg = {
    enabled = true,
    cache = helper.xdg_path('state', 'lazy/pkg-cache.lua'),
    sources = {
      'lazy', -- 'rockspec', 'packspec', },
    },
  },
  rocks = {
    enabled = false,
    root = helper.xdg_path('data', 'lazy-rocks'),
    server = 'https://nvim-neorocks.github.io/rocks-binaries/',
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = 'single',
    custom_keys = {
      ['p'] = function(plugin)
        require('lazy.util').float_term({ 'tig' }, {
          cwd = plugin.dir,
        })
      end,
    },
    -- icons = require('icon').lazy,
  },
} ---}}}

return {
  setup = function()
    options.spec = {
      { 'nvim-lua/plenary.nvim', lazy = true },
      { import = 'plugin.colorscheme' },
      { import = 'test_plugin' },
      -- { import = 'plugin.denops' },
    }
    require('lazy').setup(options)
    vim.api.nvim_create_autocmd('UIEnter', {
      once = true,
      callback = function()
        vim.cmd.colorscheme(vim.g.colors_name)
      end,
    })
  end,
}
