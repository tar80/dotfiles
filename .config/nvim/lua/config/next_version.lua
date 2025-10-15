if vim.fn.has('nvim-0.12') == 0 then
  return
end

vim.opt.diffopt:append('inline:word')
vim.keymap.del('n', 'grt')

require('vim._extui').enable({
  enable = true,
  msg = {
    ---@type 'cmd'|'msg'
    target = 'cmd',
    timeout = 4000,
  },
})

local augroup = vim.api.nvim_create_augroup('config/next_version', {})

---Remove ignore history from cmdline history{{{2
---@see https://blog.atusy.net/2023/07/24/vim-clean-history/
local delete_history = vim.regex([=[^\(mes\%[sages]\|he\%[lp]\)\_.*$]=])
vim.api.nvim_create_autocmd('CmdlineLeavePre', {
  desc = 'Remove ignore history',
  pattern = ':',
  group = augroup,
  callback = function()
    vim.schedule(function()
      for i = 1, 2 do
        local text = vim.fn.histget(':', -i)
        if text ~= '' and (#text < 2 or delete_history:match_str(text)) then
          vim.fn.histdel(':', -i)
        end
      end
    end)
  end,
})
