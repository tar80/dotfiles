return {
  cmd = { require('helper').scoop_apps('apps/deno/current/deno.exe'), 'lsp' },
  root_dir = function(fname)
    return vim.fs.root(fname, {'.git', 'tsconfig.json', 'deno.json', 'deno.jsonc'})
  end,
  autostart = true,
  disable_formatting = true,
  filetypes = { 'typescript', 'javascript' },
  settings = {
    deno = {
      inlayHints = {
        parameterNames = { enabled = 'all' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
