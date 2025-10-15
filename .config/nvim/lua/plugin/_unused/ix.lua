-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

-- local extension_icons = {
--   vsnip = ' ',
--   dictionary = ' ',
--   nvim_lua = ' ',
--   nvim_lsp_signature_help = ' ',
--   buffer = ' ',
--   path = ' ',
--   cmdline = ' ',
-- }

return {
  'hrsh7th/nvim-ix',
  dependencies = {
    'hrsh7th/nvim-cmp-kit',
    'hrsh7th/vim-vsnip',
  },
  event = { 'CursorMoved', 'InsertEnter', 'CmdlineEnter' },
  config = function()
    local ix = require('ix')
    local attach_insert_mode = ix.get_default_config().attach.insert_mode
    local lsp_kind = require('cmp-kit.kit.LSP').CompletionItemKind
    local tartar_kind = require('tartar.icon.kind')
    local helper = require('helper')
    local feedkey = helper.feedkey

    ---@desc Vsnip
    vim.g.vsnip_snippet_dir = helper.xdg_path('config', '.vsnip')

    ix.setup({
      expand_snippet = function(snippet_body)
        -- vim.snippet.expand(snippet) -- for `neovim built-in` users
        vim.fn['vsnip#anonymous'](snippet_body) -- for `vim-vsnip` users
      end,

      completion = {
        ---Enable/disable auto completion.
        auto = true,

        ---Enable/disable auto documentation.
        auto_docs = true,

        ---Enable/disable auto select first item in completion menu.
        auto_select_first = false,

        ---Enable/disable LSP's preselect feature.
        preselect = true,

        ---Default keyword pattern for completion.
        ---@type string
        default_keyword_pattern = require('cmp-kit.completion.ext.DefaultConfig').default_keyword_pattern,

        ---Performance related configuration.
        ---@type cmp-kit.completion.CompletionService.Config.Performance
        performance = {
          fetching_timeout_ms = 120,
          menu_update_throttle_ms = 32,
        },

        ---Resolve LSP's CompletionItemKind to icons.
        ---@type nil|fun(kind: cmp-kit.kit.LSP.CompletionItemKind): { [1]: string, [2]?: string }?
        -- icon_resolver = (function()
        --   local cache = {}
        --
        --   local CompletionItemKindLookup = {}
        --   for k, v in pairs(lsp_kind) do
        --     CompletionItemKindLookup[v] = k
        --   end
        --
        --   ---@param completion_item_kind cmp-kit.kit.LSP.CompletionItemKind
        --   ---@return { [1]: string, [2]?: string }?
        --   return function(completion_item_kind)
        --     if not cache[completion_item_kind] then
        --       local kind = CompletionItemKindLookup[completion_item_kind] or 'text'
        --       cache[completion_item_kind] = { tartar_kind[kind] .. '  ' }
        --     end
        --     return cache[completion_item_kind]
        --   end
        -- end)(),

        ---LSP related configuration.
        ---@type { servers?: table<string, ix.source.completion.attach_lsp.ServerConfiguration> }
        lsp = {
          ---Configuration for lsp servers.
          ---@type table<string, ix.source.completion.attach_lsp.ServerConfiguration>
          servers = {},
        },
      },

      ---Signature help configuration.
      signature_help = {
        auto = true,
      },

      ---Attach services for each per modes.
      attach = {
        ---Insert mode service initialization.
        ---NOTE: This is an advanced feature and is subject to breaking changes as the API is not yet stable.
        ---@type fun(): nil
        insert_mode = function()
          if vim.bo.filetype == 'snacks_picker_input' then
            return false
          end
          if vim.g['skkeleton#enabled'] then
            return false
          end
          attach_insert_mode()
        end,
        ---Cmdline mode service initialization.
        ---NOTE: This is an advanced feature and is subject to breaking changes as the API is not yet stable.
        ---@type fun(): nil
        cmdline_mode = function()
          local service = ix.get_completion_service({ recreate = true })
          if vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype()) then
            service:register_source(ix.source.completion.buffer(), { group = 1 })
          elseif vim.fn.getcmdtype() == ':' then
            service:register_source(
              ix.source.completion.path({
                get_cwd = function()
                  return vim.fn.getcwd()
                end,
              }),
              { group = 1 }
            )
            service:register_source(ix.source.completion.cmdline(), { group = 10 })
          end
        end,
      },
    })

    do
      vim.keymap.set({ 'i', 'c' }, '<C-d>', ix.action.scroll(0 + 3))
      vim.keymap.set({ 'i', 'c' }, '<C-u>', ix.action.scroll(0 - 3))

      vim.keymap.set({ 'i', 'c' }, '<C-Space>', ix.action.completion.complete())
      vim.keymap.set({ 'i', 'c' }, '<C-n>', ix.action.completion.select_next())
      vim.keymap.set({ 'i', 'c' }, '<C-p>', ix.action.completion.select_prev())
      vim.keymap.set({ 'i', 'c' }, '<C-e>', ix.action.completion.close())
      ix.charmap.set('c', '<CR>', ix.action.completion.commit_cmdline())
      ix.charmap.set('i', '<CR>', ix.action.completion.commit({ select_first = true }))
      vim.keymap.set('i', '<Down>', ix.action.completion.select_next())
      vim.keymap.set('i', '<Up>', ix.action.completion.select_prev())
      vim.keymap.set(
        'i',
        '<C-y>',
        ix.action.completion.commit({ select_first = true, replace = true, no_snippet = true })
      )

      vim.keymap.set({ 'i', 's' }, '<C-o>', ix.action.signature_help.trigger_or_close())
      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if vim.fn['vsnip#available']() == 1 then
          if vim.api.nvim_get_mode().mode == 's' then
            feedkey('<Plug>(vsnip-jump-next)', '')
          else
            feedkey('<Plug>(vsnip-expand-or-jump)', '')
          end
        else
          ix.action.signature_help.select_next(function()
            return '<C-j>'
          end)
        end
      end)
      vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if vim.fn['vsnip#jumpable'](-1) == 1 then
          feedkey('<Plug>(vsnip-jump-prev)', '')
        elseif vim.fn['vsnip#available']() == 1 then
          feedkey('<Plug>(vsnip-expand-or-jump)', '')
        else
          ix.action.signature_help.select_next(function()
            return '<C-k>'
          end)
        end
      end)
    end
  end,
}
