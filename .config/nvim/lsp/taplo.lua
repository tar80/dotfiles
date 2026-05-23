---@brief
---
--- https://taplo.tamasfe.dev/cli/usage/language-server.html
---
--- Language server for Taplo, a TOML toolkit.
---
--- `taplo-cli` can be installed via `cargo`:
--- ```sh
--- cargo install --features lsp --locked taplo-cli
--- ```

local taplo_path = require('helper').mason_apps('taplo/taplo.exe')

---@type vim.lsp.Config
return {
  cmd = { taplo_path, 'lsp', 'stdio' },
  filetypes = { 'toml' },
  root_markers = { '.taplo.toml', 'taplo.toml', '.git', 'jj.toml' },
}
