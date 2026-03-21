if vim.fn.has('nvim-0.12') == 0 then
  return
end

local augroup = vim.api.nvim_create_augroup('config/next_version', {})

vim.opt.diffopt:append('inline:word')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'grx')

local success, ui = pcall(require, 'vim._core.ui2')

if success and ui.enable then
  ui.enable({
    enable = true,
    msg = {
      ---@type 'cmd'|'msg'
      target = 'cmd',
      timeout = 4000,
    },
  })
else
  vim.notify('failed to load vim._core.ui2', 4, {})
end

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
