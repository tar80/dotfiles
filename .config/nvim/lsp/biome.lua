return {
  cmd = { require('helper').scoop_apps('apps/biome/current/biome.exe'), 'lsp-proxy' },
  root_dir = function(fname)
    return vim.fs.root(fname, { 'biome.json', 'biome.jsonc' })
  end,
  autostart = true,
  single_file_support = false,
  capabilities = vim.NIL,
  -- filetypes = { 'typescript', 'javascript', 'json', 'jsonc', 'css' },
  filetypes = { 'json', 'jsonc', 'css' },
}
