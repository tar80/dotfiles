return {
  'lambdalisue/vim-mr',
  event = 'VeryLazy',
  init = function()
    vim.api.nvim_set_var('mr_mrd_disabled', true)
    vim.api.nvim_set_var('mr_mrr_disabled', true)
    -- vim.api.nvim_set_var('mr_mru_disabled', true)
    vim.api.nvim_set_var('mr_mrw_disabled', true)
    vim.api.nvim_set_var('mr#threshold', 200)
    vim.cmd(
      "let g:mr#mru#predicates=[{filename -> filename !~? '^c|\\\\\\|\\/doc\\/\\|\\/dist\\/\\|\\/\\.git\\/\\|\\.cache'}]"
    )
  end,
}
