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
o.undofile = false
o.showtabline = 2
o.laststatus = 3
o.cmdheight = 1
o.number = true
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

keymap.set('n', '<Laeder><Leader>w', helper.toggleWrap)
keymap.set('n', '<C-z>', '<NOP>')
keymap.set('n', ',', function()
  if o.hlsearch then
    o.hlsearch = false
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
---Move buffer use <Space>
keymap.set('n', '<Space>', '<C-W>', { remap = true })
keymap.set('n', '<Space><Space>', '<C-W><C-W>')
keymap.set('n', '<Space>n', helper.scratch_buffer)
keymap.set('n', '<Space>c', '<Cmd>tabclose<CR>')

---@desc Insert & Command {{{2
keymap.set('!', '<C-q>u', '<C-R>=nr2char(0x)<Left>')
keymap.set('i', '<C-q>q', function()
  local line = api.nvim_get_current_line()
  local col = api.nvim_win_get_cursor(0)[2]
  local substring = line:sub(1, col)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return ('<C-w>%s'):format(result:upper())
end, { expr = true })
keymap.set('i', '<M-j>', '<C-g>U<Down>')
keymap.set('i', '<M-k>', '<C-g>U<Up>')
keymap.set('i', '<M-h>', '<C-g>U<Left>')
keymap.set('i', '<M-l>', '<C-g>U<Right>')
keymap.set('i', '<S-Delete>', '<C-g>U<C-o>D')
keymap.set('i', '<C-k>', '<Delete>')
keymap.set('i', '<C-f>', '<Right>')
keymap.set('i', '<C-b>', '<Left>')
keymap.set('i', '<C-z>', '<C-a><Esc>')
keymap.set('i', '<C-u>', '<Cmd>normal u<CR>')
keymap.set('c', '<C-a>', '<Home>')
keymap.set('c', '<C-b>', '<Left>')

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
