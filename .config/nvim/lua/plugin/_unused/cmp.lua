-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local extension_icons = {
  vsnip = '',
  dictionary = '',
  nvim_lua = '',
  nvim_lsp_signature_help = '',
  buffer = '',
  path = '',
  cmdline = '',
}

return {
  'hrsh7th/nvim-cmp',
  event = { 'CursorMoved', 'InsertEnter', 'CmdlineEnter' },
  dependencies = { -- {{{
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/vim-vsnip',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'dmitmel/cmp-cmdline-history',
    -- 'zbirenbaum/copilot.lua',
    -- 'zbirenbaum/copilot-cmp',
    { 'uga-rosa/cmp-dictionary', opts = { first_case_insensitive = true } },
  }, -- }}}
  config = function()
    local cmp = require('cmp')
    local icon = vim.tbl_deep_extend('force', extension_icons, require('tartar.icon.kind'))
    local quote_border = require('tartar.helper').generate_quotation('PmenuMatch')
    local helper = require('helper')
    local feedkey = helper.feedkey

    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })
    ---@desc Vsnip
    vim.g.vsnip_snippet_dir = helper.xdg_path('config', '.vsnip')

    ---@desc kinds{{{
    local kind = {
      vsnip = { icon = icon.vsnip, alias = 'V-snip' },
      dictionary = { icon = icon.dictionary, alias = 'Dictionary' },
      nvim_lsp = { icon = nil, alias = 'Lsp' },
      nvim_lua = { icon = icon.nvim_lua, alias = nil },
      nvim_lsp_signature_help = { icon = icon.nvim_lsp_signature_help, alias = nil },
      buffer = { icon = icon.buffer, alias = 'Buffer' },
      path = { icon = icon.path, alias = nil },
      cmdline = { icon = icon.cmdline, alias = nil },
      -- copilot = { icon = icon.Copilot, alias = 'Copilot' },
    }
    local display_kind = function(entry, item)
      local v = kind[entry.source.name]
      if v then
        if v.alias == 'Lsp' then
          v.icon = icon[item.kind]
        end
        item.kind = v.icon
        -- item.kind = string.format('%s%s', v.icon, v.alias or item.kind)
      end
      return item
    end
    local no_display_kind = function(_, item)
      item.kind = ''
      return item
    end -- }}}
    cmp.setup({ -- {{{
      enabled = function()
        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        end
        if vim.bo.filetype == 'snacks_picker_input' then
          return false
        end
        if vim.g['skkeleton#enabled'] then
          return false
        end
        return true
      end,
      -- completion = { keyword_length = 2 },
      performance = { debounce = 30, throttle = 30 },
      -- experimental = { ghost_text = { hl_group = 'CmpGhostText' } },
      window = {
        completion = { scrolloff = 1, side_padding = 1 },
        documentation = { border = quote_border },
      },
      snippet = { -- {{{
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body)
        end,
      }, -- }}}
      sources = cmp.config.sources({ -- {{{
        { name = 'vsnip' },
        { name = 'nvim_lsp', max_item_count = 20 },
        { name = 'nvim_lsp_signature_help' },
        -- { name = 'copilot' },
        { name = 'dictionary', keyword_length = 2 },
        {
          name = 'buffer',
          max_item_count = 50,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        { name = 'path', keyword_length = 2 },
        -- { name = 'nvim_lua', keyword_length = 2 },
        { name = 'render-markdown' },
      }), -- }}}
      formatting = { -- {{{
        -- fields = {'menu','abbr','kind'},
        format = function(entry, item)
          return display_kind(entry, item)
        end,
      }, -- }}}
      mapping = { -- {{{
        ['<C-p>'] = cmp.mapping(function()
          return cmp.visible() and cmp.select_prev_item() or cmp.complete()
        end, { 'i', 'c' }),
        ['<C-n>'] = cmp.mapping(function()
          return cmp.visible() and cmp.select_next_item() or cmp.complete()
        end, { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping(function(_)
          return cmp.visible() and cmp.abort() or feedkey('<Home>', '')
        end, { 'i' }),
        ['<C-y>'] = cmp.mapping(function(_)
          return cmp.visible() and cmp.close() or feedkey('<End>', '')
        end, { 'i' }),
        ['<Down>'] = cmp.mapping.scroll_docs(4),
        ['<Up>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-d>'] = cmp.mapping(function(fallback)
        --   return cmp.visible() and cmp.mapping.scroll_docs(4) or fallback()
        -- end, { 'i', 'c' }),
        -- ['<C-u>'] = cmp.mapping(function(fallback)
        --   return cmp.visible() and cmp.mapping.scroll_docs(-4) or fallback()
        -- end, { 'i', 'c' }),
        ['<CR>'] = function(fallback)
          if cmp.visible() and (cmp.get_selected_entry() ~= nil) then
            return cmp.confirm({ select = false })
          end
          fallback()
        end,
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(function()
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   end
        -- end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function(fallback)
          if vim.fn['vsnip#available']() == 1 then
            if vim.api.nvim_get_mode().mode == 's' then
              feedkey('<Plug>(vsnip-jump-next)', '')
            else
              feedkey('<Plug>(vsnip-expand-or-jump)', '')
            end
          elseif cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
          if vim.fn['vsnip#jumpable'](-1) == 1 then
            feedkey('<Plug>(vsnip-jump-prev)', '')
          elseif vim.fn['vsnip#available']() == 1 then
            feedkey('<Plug>(vsnip-expand-or-jump)', '')
            -- elseif cmp.visible() then
            --   cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-a>'] = cmp.mapping(function()
          feedkey('<Esc>a', '')
        end, { 's' }),
      }, -- }}}
    }) -- }}}
    cmp.setup.cmdline('/', { -- {{{
      -- window = {
      --   completion = cmp.config.window.bordered(),
      -- },
      completion = { keyword_length = 1 },
      sources = cmp.config.sources({
        { name = 'buffer' },
      }),
      formatting = {
        format = function(entry, item)
          return no_display_kind(entry, item)
        end,
      },
      mapping = cmp.mapping.preset.cmdline(),
    }) -- }}}
    cmp.setup.cmdline(':', { -- {{{
      window = {
        completion = { scrolloff = 1 },
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      completion = { keyword_length = 2 },
      sources = cmp.config.sources(
        { { name = 'path', max_item_count = 20 } },
        { { name = 'cmdline', max_item_count = 20 } },
        { { name = 'cmdline_history', max_item_count = 20 } }
      ),
      formatting = {
        format = function(entry, item)
          return no_display_kind(entry, item)
        end,
      },
      mapping = cmp.mapping.preset.cmdline(),
    }) -- }}}
    local config_home = os.getenv('XDG_CONFIG_HOME')
    require('cmp_dictionary').setup({ -- {{{
      paths = {
        -- vim.g.repo .. '/myrepo/nvim/after/dict/lua.dict',
        config_home .. '/nvim/after/dict/javascript.dict',
        config_home .. '/nvim/after/dict/PPxcfg.dict',
      },
      exact_length = 2,
      first_case_insensitive = true,
    }) -- }}}
    -- require('copilot').setup({
    --   filetypes = {
    --     lua = true,
    --     typescript = true,
    --     gitcommit = false,
    --     ['*'] = false,
    --   },
    --   panels = { enable = false },
    --   suggestions = { enable = false },
    -- })
    --   auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
    --   logger = {
    --     file = vim.fn.stdpath('log') .. '/copilot-lua.log',
    --     file_log_level = vim.log.levels.OFF,
    --     print_log_level = vim.log.levels.WARN,
    --     trace_lsp = 'off', -- "off" | "messages" | "verbose"
    --     trace_lsp_progress = false,
    --     log_lsp_messages = false,
    --   },
    --   copilot_node_command = 'node', -- Node.js version must be > 20
    --   workspace_folders = {},
    --   copilot_model = '',
    --   root_dir = function()
    --     return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
    --   end,
    --   should_attach = function(_, _)
    --     if not vim.bo.buflisted then
    --       logger.debug("not attaching, buffer is not 'buflisted'")
    --       return false
    --     end
    --
    --     if vim.bo.buftype ~= '' then
    --       logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
    --       return false
    --     end
    --
    --     return true
    --   end,
    --   server = {
    --     type = 'nodejs', -- "nodejs" | "binary"
    --     custom_server_filepath = nil,
    --   },
    --   server_opts_overrides = {},
    -- })
    -- require('copilot_cmp').setup()
  end,
}
