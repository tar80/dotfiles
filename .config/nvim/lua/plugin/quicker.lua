-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

return {
  'stevearc/quicker.nvim',
  ft = { 'qf' },
  config = {
    use_default_opts = true,
    keys = {
      { '>', "<cmd>lua require('quicker').expand()<CR>", desc = 'Expand quickfix content' },
      { '<', "<cmd>lua require('quicker').collapse()<CR>", desc = 'Collapse quickfix content' },
    },
    opts = {
      buflisted = false,
      number = true,
      relativenumber = true,
      signcolumn = 'auto',
      winfixheight = true,
      wrap = false,
    },
    highlight = {
      treesitter = true,
      lsp = true,
      load_buffers = false,
    },
    constrain_cursor = true,
    max_filename_width = function()
      return 32
    end,
  },
}
