---@brief
---
--- https://github.com/EmmyLuaLs/emmylua-analyzer-rust
---
--- Emmylua Analyzer Rust. Language Server for Lua.
---
--- `emmylua_ls` can be installed using `cargo` by following the instructions[here]
--- (https://github.com/EmmyLuaLs/emmylua-analyzer-rust?tab=readme-ov-file#install).
---
--- The default `cmd` assumes that the `emmylua_ls` binary can be found in `$PATH`.
--- It might require you to provide cargo binaries installation path in it.

local helper = require('helper')
local root = helper.mason_apps('emmylua_ls')

---@type vim.lsp.Config
return {
  cmd = { root .. '/emmylua_ls.exe' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.emmyrc.json',
    '.stylua.toml',
    '.luacheckrc',
    '.git',
  },
  workspace_required = false,
}
