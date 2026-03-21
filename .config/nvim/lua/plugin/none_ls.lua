-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

return {
  'nvimtools/none-ls.nvim',
  ft = { 'text', 'markdown', 'yaml' },
  dependencies = { 'williamboman/mason.nvim' },
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      debounce = 500,
      root_dir = function()
        return vim.uv.cwd()
      end,
      temp_dir = vim.fn.tempname():gsub('^(.+)[/\\].*', '%1'),
      on_attach = function(_, bufnr)
        vim.keymap.set('n', 'gla', function()
          vim.lsp.buf.code_action({ apply = true, bufnr = bufnr })
        end, { desc = 'Lsp code action' })
      end,
      sources = {
        null_ls.builtins.diagnostics.markdownlint.with({
          filetypes = { 'markdown' },
          extra_args = { '--config', vim.fn.stdpath('config') .. '/.markdownlint.yaml' },
          diagnostic_config = {
            virtual_text = {
              format = function(diagnostic)
                return string.format('%s: %s', diagnostic.source, diagnostic.code)
              end,
            },
          },
        }),
        null_ls.builtins.diagnostics.textlint.with({
          filetypes = { 'text', 'markdown' },
          extra_args = { '--config', os.getenv('HOME') .. '/.textlintrc.json' },
          diagnostic_config = {
            virtual_text = {
              format = function(diagnostic)
                return string.format('%s: [%s] %s', diagnostic.source, diagnostic.code, diagnostic.message)
              end,
            },
            signs = false,
          },
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),
        null_ls.builtins.code_actions.textlint.with({
          extra_args = { '--config', os.getenv('HOME') .. '/.textlintrc.json' },
        }),
        null_ls.builtins.diagnostics.actionlint.with({
          filetypes = { 'yaml' },
          diagnostic_config = {
            virtual_text = {
              format = function(diagnostic)
                return string.format('%s: [%s] %s', diagnostic.source, diagnostic.code, diagnostic.message)
              end,
            },
          },
        }),
      },
    })
  end,
}
