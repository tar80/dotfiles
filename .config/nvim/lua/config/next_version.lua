if vim.fn.has('nvim-0.13') == 0 then
  return
end

-- local augroup = vim.api.nvim_create_augroup('config/next_version', {})


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
