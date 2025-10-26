-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------
---@class Severities
---@field Error string
---@field Warn string
---@field Hint string
---@field Info string

local api = vim.api
local lsp = vim.lsp
local keymap = vim.keymap
local helper = require('helper')
local icon = require('tartar.icon.symbol')

local UNIQUE_NAME = 'rc_lsp'
local RENAME_TITLE = 'LspRename'
-- local FLOAT_BORDER = vim.g.float_border
---@type Severities
local SEVERITIES = icon.diagnostics

local augroup = api.nvim_create_augroup(UNIQUE_NAME, {})

---Renames all references to the symbol under the cursor {{{2
local function popup_rename()
  local ok, mug_float = pcall(require, 'mug.module.float')
  if not ok then
    return
  end
  local adjust_cursor = helper.getchr():match('[^%w]')
  if adjust_cursor then
    vim.cmd.normal('h')
  end
  local rename_old = vim.fn.expand('<cword>')
  if adjust_cursor or not helper.has_words_before() then
    vim.cmd.normal('l')
  end
  mug_float.input({
    title = RENAME_TITLE,
    width = math.max(25, #rename_old + 8),
    border = 'double',
    relative = 'cursor',
    contents = function()
      return rename_old
    end,
    post = function()
      vim.wo.eventignorewin = 'WinLeave'
      keymap.set('i', '<CR>', function()
        vim.cmd.stopinsert({ bang = true })
        local input = api.nvim_get_current_line()
        local msg = string.format('%s -> %s', rename_old, input)
        api.nvim_win_close(0, false)
        lsp.buf.rename(vim.trim(input))
        vim.notify(msg, 2, { title = RENAME_TITLE })
      end, { buffer = true })
    end,
  })
end -- }}}

---Highlight the symbol under the cursor {{{2
---@param _client vim.lsp.Client
---@param bufnr integer
---@return integer
local function cursorword(_client, bufnr)
  local ts = require('tartar.treesitter')
  local tartar_helper = require('tartar.helper')
  local lsp_reference_ns = api.nvim_get_namespaces()['nvim.lsp.references']
  return api.nvim_create_autocmd({ 'CursorHold' }, {
    desc = 'Set document highlighting',
    group = augroup,
    buffer = bufnr,
    callback = function()
      if tartar_helper.is_insert_mode() then
        return
      end
      local cur = api.nvim_win_get_cursor(0)
      cur[1] = cur[1] - 1
      if lsp_reference_ns then
        local extmarks = api.nvim_buf_get_extmarks(0, lsp_reference_ns, 0, -1, { details = true })
        if extmarks[1] then
          local is_range = vim.iter(extmarks):find(function(extmark)
            local tsrange = { extmark[2], extmark[3], extmark[4].end_row, extmark[4].end_col + 1 }
            return ts.is_range(cur[1], cur[2], tsrange)
          end)
          if is_range then
            return
          end
        end
        lsp.buf.clear_references()
        lsp.buf.document_highlight()
      end
    end,
  })
end -- }}}

---Get severity details {{{2
---@param sign_icon string
---@return {text?: Severities, numhl?: Severities, linehl?: Severities}
local function get_signs(sign_icon)
  local o = { text = {}, linehl = {}, numhl = {} }
  for name, _ in pairs(SEVERITIES) do
    local key = vim.diagnostic.severity[name:upper()]
    o.text[key] = sign_icon
  end
  return o
end -- }}}

---@desc Lsp options
vim.diagnostic.config({ -- {{{2
  virtual_text = false,
  virtual_lines = false,
  severity_sort = true,
  update_in_insert = false,
  signs = get_signs(icon.mark.round_square_s),
  float = {
    focusable = true,
    style = 'minimal',
    -- border = FLOAT_BORDER,
    source = false,
    header = '',
    prefix = '',
    suffix = '',
    format = function(diagnostic)
      local symbol = { [1] = SEVERITIES.Error, [2] = SEVERITIES.Warn, [3] = SEVERITIES.Info, [4] = SEVERITIES.Hint }
      return string.format('%s %s (%s)', symbol[diagnostic.severity], diagnostic.message, diagnostic.source)
    end,
  },
}) -- }}}

local float_opts = {
  max_width = 80,
  wrap_at = 80,
  border = require('tartar.helper').generate_quotation(),
  anchor_bias = 'below',
}

api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local client = assert(lsp.get_client_by_id(args.data.client_id))
    -- local capa = client.server_capabilities
    pcall(keymap.del, 'n', 'K', { buffer = args.buf })

    keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -vim.v.count1, float = true })
    end, { desc = 'Jump to the previous diagnostic in the current buffer' })
    keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = vim.v.count1, float = true })
    end, { desc = 'Jump to the next diagnostic in the current buffer' })
    vim.keymap.set('n', ']D', function()
      vim.diagnostic.jump({ count = vim._maxint, float = true })
    end, { desc = 'Jump to the last diagnostic in the current buffer' })
    vim.keymap.set('n', '[D', function()
      vim.diagnostic.jump({ count = -vim._maxint, float = true })
    end, { desc = 'Jump to the first diagnostic in the current buffer' })

    keymap.set('n', 'gld', function() -- {{{
      local opts = { bufnr = 0, focusable = false }
      local opts_cursor = vim.tbl_extend('force', opts, { scope = 'cursor' })
      local winblend = api.nvim_get_option_value('winblend', {})
      api.nvim_set_option_value('winblend', 0, {})
      local resp = vim.diagnostic.open_float(opts_cursor, {})
      if not resp then
        local opts_line = vim.tbl_extend('force', opts, { scope = 'line' })
        vim.diagnostic.open_float(opts_line, {})
      end

      api.nvim_set_option_value('winblend', winblend, {})
    end, { desc = 'Lsp diagnostic' }) -- }}}
    keymap.set('n', 'glh', function()
      lsp.buf.signature_help(float_opts)
    end, { desc = 'Lsp signature help' })
    keymap.set('n', 'gll', function()
      lsp.buf.hover(float_opts)
    end, { desc = 'Lsp hover' })
    if client:supports_method('textDocument/inlayHint') then
      keymap.set('n', 'gli', function() -- {{{
        local toggle = not lsp.inlay_hint.is_enabled({ bufnr = args.buf })
        lsp.inlay_hint.enable(toggle)
      end, { desc = 'Lsp inlay hints' }) -- }}}
    end
    if client:supports_method('textDocument/rename') then
      keymap.set('n', 'gln', popup_rename, { desc = 'Lsp popup rename' })
    end
    if client:supports_method('textDocument/codeAction') then
      keymap.set('n', 'gla', lsp.buf.code_action, { desc = 'Lsp code action' })
    end
    keymap.set('n', 'glv', function() -- {{{
      local toggle = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = toggle })
    end, { desc = 'Lsp virtual lines' }) -- }}}
  end,
})

local enable_types = {
  'denols',
  'lua_ls',
  -- 'emmylua_ls',
  'jsonls',
  'ts_ls',
}

-- vim.lsp.config('*', {
--   capabilities = {
--     textDocument = {
--       semanticTokens = {
--         multilineTokenSupport = true,
--       },
--     },
--   },
--   root_markers = { '.git' },
-- })

vim.keymap.set({ 'i', 'n' }, '<F13>', function()
  local state = 'Disebled'
  if vim.lsp.is_enabled('copilot_ls') then
    vim.lsp.enable('copilot_ls', false)
  else
    state = 'Enabled'
    vim.lsp.enable('copilot_ls')
  end
  return print(('%s copilot'):format(state))
end, { desc = 'Copilot toggle' })

lsp.enable(enable_types)
