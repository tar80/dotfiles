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
local _root = helper.mason_apps('emmylua_ls')
local lazy_plugins = helper.xdg_path('data', 'lazy')

local PLACE_HOLDER = '-- workspace='
local WORKSPACE_LIBRARIES = {
  '$VIMRUNTIME/lua/vim',
  '$VIMRUNTIME/lua/uv/_meta.lua',
}
local TEST_LIBRARIES = {
  lazy_plugins .. '/plenary.nvim/lua/plenary/busted.lua',
  lazy_plugins .. '/plenary.nvim/lua/luassert',
}
local rgx_ph = vim.regex('^' .. PLACE_HOLDER)
local rgx_spec = vim.regex('_spec.lua$')

local function get_workspace()
  local library = vim.list_extend({}, WORKSPACE_LIBRARIES)
  local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  if line and rgx_ph:match_str(line) then
    local buf_workspace = line:gsub(PLACE_HOLDER, '', 1)
    table.insert(library, buf_workspace)
  end
  local bufname = vim.api.nvim_buf_get_name(0)
  if rgx_spec:match_str(bufname) then
    for _, path in ipairs(TEST_LIBRARIES) do
      table.insert(library, path)
    end
  end
  return library
end

---@type vim.lsp.Config
return {
  cmd = { _root .. '/emmylua_ls.exe' },
  filetypes = { 'lua' },
  root_markers = {
    '.emmyrc.json',
    '.stylua.toml',
    '.git',
  },
  workspace_required = false,
  settings = {
    Lua = {
      codeLens = { enable = true },
      signature = { detailSignatureHelper = true },
      completion = {
        callSnippet = true,
        postfix = '%',
      },
      diagnostics = {
        globals = { 'vim', 'nyagos', 'Snacks' },
      },
      runtime = {
        version = 'LuaJIT',
        requirePattern = { '?.lua', '?/init.lua', '?/types.lua' },
      },
      semanticTokens = { enable = false },
    },
  },
  on_init = function(client, _)
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
      workspace = {
        -- ignoreDir = { 'tests', 'spec' },
        library = get_workspace(),
      },
    })
  end,
}
