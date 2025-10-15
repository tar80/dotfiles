-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local opt = vim.opt
local o = vim.o

---@desc Options {{{1
---Global {{{2
vim.api.nvim_set_option_value('termguicolors', true, { scope = 'global' })
vim.api.nvim_set_option_value('fileformats', 'unix,dos,mac', { scope = 'global' })
vim.api.nvim_set_option_value('hlsearch', false, { scope = 'global' })
vim.api.nvim_set_option_value('modelines', 2, { scope = 'global' })
vim.api.nvim_set_option_value('shada', "'10,<500,/10,:100,h", { scope = 'global' })
vim.api.nvim_set_option_value('winborder', 'single', { scope = 'global' })
-- vim.api.nvim_set_option_value('equalalways', false, { scope = 'global' })

---Local {{{2
-- NOTE: api.nvim_set_option_value('name', value, { scope = 'local' })
vim.opt_global.isfname:append(':')

---General {{{2
o.guicursor = 'n:block,i-c-ci-ve:ver50,v-r-cr-o:hor50'
-- o.fileencodings = 'utf-8,utf-16le,cp932,euc-jp,sjis'
o.fileencodings = 'utf-8,cp932,euc-jp,utf-16le'
-- o.timeoutlen = 1000
o.updatetime = vim.g.update_time
-- o.autochdir = true
o.diffopt =
  'algorithm:histogram,closeoff,filler,hiddenoff,indent-heuristic,internal,iwhite,iwhiteeol,linematch:40,vertical'
--version 0.12 or later: o.diffopt = 'algorithm:histogram,closeoff,filler,hiddenoff,indent-heuristic,internal,iwhite,iwhiteeol,linematch:40,vertical,inline:word'
-- o.backup= false
o.swapfile = false
o.undofile = true
o.history = 300
o.ambiwidth = 'single'
o.gdefault = true
o.ignorecase = true
o.smartcase = true
o.formatoptions = 'mMjql'
o.wrap = false
o.wrapscan = false
o.whichwrap = '<,>,[,],h,l'
o.linebreak = true
o.breakindent = true
o.showbreak = '>>'
o.scrolloff = 1
o.sidescroll = 6
o.sidescrolloff = 3
o.lazyredraw = false
o.list = true
opt.listchars = { tab = '| ', extends = '<', precedes = '>', trail = '_' }
o.confirm = true
-- o.display = 'lastline'
o.showmode = false
o.showtabline = 2
o.laststatus = 2
o.cmdheight = 1
o.number = true
o.ruler = false
-- o.numberwidth = 4
o.relativenumber = true
o.signcolumn = 'yes'
-- o.backspace = { indent = true,eol = true, start = true }
o.complete = '.,w'
opt.completeopt = { menu = true, menuone = true, noselect = true }
o.winblend = 10
o.pumblend = 12
o.pumheight = 10
o.pumwidth = 20
o.matchtime = 2
opt.matchpairs:append({ '【:】', '[:]' })
-- vim.cmd[[set tabstop<]]
o.shiftwidth = 2
o.softtabstop = 2
o.shiftround = true
o.expandtab = true
o.virtualedit = 'block'
-- o.wildmenu = true
opt.wildmode = { 'longest:full', 'full' }
opt.wildoptions:remove({ 'tagfile' })
opt.spelllang:append({ 'cjk' })
opt.shortmess:append('csS')
opt.shortmess:remove({ 'fF' })
-- opt.fillchars = { vert = "█", vertleft = "█", vertright = "█", verthoriz = "█", horiz = "█", horizup = "█", horizdown = "█", }
opt.fillchars = { diff = ' ', foldclose = '󰅂', foldopen = '󰅀', foldsep = '┊' }
o.keywordprg = ':help'
o.helplang = 'ja'
o.helpheight = 10
o.previewheight = 8
-- opt.path = { '.', '' }
