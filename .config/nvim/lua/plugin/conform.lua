-- vim:textwidth=0:foldmethod=marker:foldlevel=2:
--------------------------------------------------------------------------------

return {
  'stevearc/conform.nvim',
  lazy = true,
  dependencies = { 'williamboman/mason.nvim' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      'gq',
      function(bufnr)
        require('conform').format({ async = true, bufnr = bufnr, lsp_format = 'fallback' })
      end,
      mode = { 'n' },
      desc = 'Format buffer',
    },
    {
      'gq',
      function(bufnr)
        require('conform').format({ async = true, bufnr = bufnr, lsp_format = 'prefer' }, function(err)
          if not err then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
          end
        end)
      end,
      mode = { 'x' },
      desc = 'Range format buffer',
    },
  },
  opts = {
    default_format_opts = { timeout_ms = 3000 },
    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'biome' },
      javascript = { 'biome-check' },
      typescript = { 'biome-check' },
      markdown = { 'markdownlint', 'prettier' },
    },
  },
}
