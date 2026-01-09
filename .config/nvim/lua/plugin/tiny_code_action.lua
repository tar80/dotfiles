-- vim:textwidth=0:foldmethod=marker:foldlevel=2:

return {
  'rachartier/tiny-code-action.nvim',
  dependencies = { 'plenary.nvim', 'snacks.nvim' },
  event = 'LspAttach',
  opts = {
    backend = 'vim',
    picker = 'snacks',
    resolve_timeout = 100,
    notify = {
      enabled = true,
      on_empty = true,
    },
    signs = {
      quickfix = { '', { link = 'DiagnosticWarning' } },
      others = { '', { link = 'DiagnosticWarning' } },
      refactor = { '', { link = 'DiagnosticInfo' } },
      ['refactor.move'] = { '󰪹', { link = 'DiagnosticInfo' } },
      ['refactor.extract'] = { '', { link = 'DiagnosticError' } },
      ['source.organizeImports'] = { '', { link = 'DiagnosticWarning' } },
      ['source.fixAll'] = { '󰃢', { link = 'DiagnosticError' } },
      ['source'] = { '', { link = 'DiagnosticError' } },
      ['rename'] = { '󰑕', { link = 'DiagnosticWarning' } },
      ['codeAction'] = { '', { link = 'DiagnosticWarning' } },
    },
  },
}
