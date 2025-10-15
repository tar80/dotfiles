-- vim:textwidth=0:foldmethod=marker:foldlevel=2:

return {
  'tar80/mug.nvim',
  dev = true,
  event = 'VeryLazy',
  keys = { -- {{{4
    { 'md', '<Cmd>MugDiff<CR>', mode = { 'n' }, desc = 'Mug diff' },
    { 'mi', '<Cmd>MugIndex<CR>', mode = { 'n' }, desc = 'Mug index' },
    { 'mc', '<Cmd>MugCommit<CR>', mode = { 'n' }, desc = 'Mug commit' },
  }, -- }}}
  opts = { -- {{{4
    commit = true,
    conflict = true,
    diff = true,
    files = true,
    index = true,
    merge = true,
    mkrepo = true,
    rebase = true,
    show = true,
    subcommand = true,
    terminal = true,
    variables = {
      edit_command = 'E',
      file_command = 'F',
      write_command = 'W',
      sub_command = 'G',
      -- symbol_not_repository = '',
      root_patterns = { 'lazy-lock.json', '.gitignore', '.git/' },
      index_auto_update = true,
      commit_notation = 'conventional',
      remote_url = 'git@github.com:tar80',
      diff_position = 'right',
      term_command = 'T',
      -- term_shell = 'nyagos',
      term_position = 'bottom',
      term_disable_columns = true,
      term_nvim_pseudo = true,
    },
    highlights = {},
  }
}
