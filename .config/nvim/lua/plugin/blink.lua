local helper = require('tartar.helper')
local bubble = require('tartar.icon.ui').frame.bubble
local kind_icons = require('tartar.icon.kind')
local quote_border = helper.generate_quotation('PmenuMatch')
local bubble_border = helper.generate_decorative_line(bubble.left, bubble.right, 'BlinkCmpSignatureHelpBorder')

return {
  'saghen/blink.cmp',
  -- version = '1.*',
  dependencies = {
    'fang2hou/blink-copilot',
    {
      'hrsh7th/vim-vsnip',
      init = function()
        vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/.vsnip'
      end,
    },
  },
  opts = {
    enabled = function()
      return not vim.g['skkeleton#enabled']
    end,
    keymap = { preset = 'enter' },
    appearance = { nerd_font_variant = 'mono' },
    cmdline = {
      keymap = { preset = 'cmdline' },
      completion = {
        menu = { auto_show = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        ghost_text = { enabled = false },
      },
    },
    completion = {
      keyword = { range = 'prefix' },
      trigger = {
        -- When true, will prefetch the completion items when entering insert mode
        prefetch_on_insert = true,

        -- When false, will not show the completion window automatically when in a snippet
        show_in_snippet = true,

        -- When true, will show completion window after backspacing
        show_on_backspace = false,

        -- When true, will show completion window after backspacing into a keyword
        show_on_backspace_in_keyword = false,

        -- When true, will show the completion window after accepting a completion and then backspacing into a keyword
        show_on_backspace_after_accept = false,

        -- When true, will show the completion window after entering insert mode and backspacing into keyword
        show_on_backspace_after_insert_enter = false,

        -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
        show_on_keyword = true,

        -- When true, will show the completion window after typing a trigger character
        show_on_trigger_character = true,

        -- When true, will show the completion window after entering insert mode
        show_on_insert = false,

        -- LSPs can indicate when to show the completion window via trigger characters
        -- however, some LSPs (i.e. tsserver) return characters that would essentially
        -- always show the window. We block these by default.
        show_on_blocked_trigger_characters = { ' ', '\n', '\t', '=' },
        -- You can also block per filetype with a function:
        -- show_on_blocked_trigger_characters = function(ctx)
        --   if vim.bo.filetype == 'markdown' then return { ' ', '\n', '\t', '.', '/', '(', '[' } end
        --   return { ' ', '\n', '\t' }
        -- end,

        -- When both this and show_on_trigger_character are true, will show the completion window
        -- when the cursor comes after a trigger character after accepting an item
        show_on_accept_on_trigger_character = true,

        -- When both this and show_on_trigger_character are true, will show the completion window
        -- when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,

        -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
        -- the completion window when the cursor comes after a trigger character when
        -- entering insert mode/accepting an item
        show_on_x_blocked_trigger_characters = { "'", '"', '(' },
        -- or a function, similar to show_on_blocked_trigger_character
      },
      list = {
        max_items = 100,
        selection = { preselect = false, auto_insert = true },
      },
      accept = {
        -- Write completions to the `.` register
        dot_repeat = true,
        -- Create an undo point when accepting a completion item
        create_undo_point = true,
        -- How long to wait for the LSP to resolve the item with additional information before continuing as-is
        resolve_timeout_ms = 100,
        -- Experimental auto-brackets support
        auto_brackets = {
          -- Whether to auto-insert brackets for functions
          enabled = true,
          -- Default brackets to use for unknown languages
          default_brackets = { '(', ')' },
          -- Overrides the default blocked filetypes
          -- See: https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/completion/brackets/config.lua#L5-L9
          override_brackets_for_filetypes = {},
          -- Synchronously use the kind of the item to determine if brackets should be added
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue' },
          },
          -- Asynchronously use semantic token to determine if brackets should be added
          semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = { 'java' },
            -- How long to wait for semantic tokens to return before assuming no brackets should be added
            timeout_ms = 400,
          },
        },
      },
      menu = {
        enabled = true,
        min_width = 20,
        max_height = 10,
        border = 'none',
        winblend = 20,
        -- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        scrolloff = 2,
        scrollbar = true,
        -- Which directions to show the window,
        -- falling back to the next direction when there's not enough space
        direction_priority = { 's', 'n' },
        -- Can accept a function if you need more control
        -- direction_priority = function()
        --   if condition then return { 'n', 's' } end
        --   return { 's', 'n' }
        -- end,

        -- Whether to automatically show the window when new completion items are available
        auto_show = true,
        -- Delay before showing the completion menu
        auto_show_delay_ms = 0,

        -- Screen coordinates of the command line
        -- cmdline_position = function()
        --   if vim.g.ui_cmdline_pos ~= nil then
        --     local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
        --     return { pos[1] - 1, pos[2] }
        --   end
        --   local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
        --   return { vim.o.lines - height, 0 }
        -- end,
        draw = {
          align_to = 'label', -- or 'none' to disable, or 'cursor' to align to the cursor
          padding = 1,
          gap = 1,
          cursorline_priority = 10000,
          snippet_indicator = '~',
          -- treesitter = {},
          treesitter = { 'lsp' },

          -- Components to render, grouped by column
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },

          -- Definitions for possible components to render. Each defines:
          --   ellipsis: whether to add an ellipsis when truncating the text
          --   width: control the min, max and fill behavior of the component
          --   text function: will be called for each item
          --   highlight function: will be called only when the line appears on screen
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return kind_icons[ctx.kind]
              end,
              highlight = function(ctx)
                return { { group = ctx.kind_hl, priority = 20000 } }
              end,
            },

            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return ctx.kind_hl
              end,
            },

            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                return ctx.label .. ctx.label_detail
              end,
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(
                    highlights,
                    { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' }
                  )
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end

                return highlights
              end,
            },

            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = 'BlinkCmpLabelDescription',
            },

            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.source_name
              end,
              highlight = 'BlinkCmpSource',
            },

            source_id = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.source_id
              end,
              highlight = 'BlinkCmpSource',
            },
          },
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 100, window = { border = quote_border } },
      ghost_text = {
        enabled = false,
        show_with_selection = true,
        show_without_selection = true,
        show_with_menu = true,
        show_without_menu = true,
      },
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_keyword = false,
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        show_on_trigger_character = true,
        show_on_insert = false,
        show_on_insert_on_trigger_character = true,
      },
      window = {
        min_width = 1,
        max_width = 100,
        max_height = 10,
        border = bubble_border,
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder,Search:None',
        scrollbar = false,
        direction_priority = { 'n', 's' },
        treesitter_highlighting = true,
        show_documentation = false,
      },
      file,
    },
    snippets = { preset = 'vsnip' },
    sources = {
      min_keyword_length = 2,
      default = { 'snippets', 'lsp', 'path', 'buffer', 'copilot' },
      per_filetype = { codecompanion = { 'codecompanion' } },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = -100,
          async = true,
          opts = {
            max_completions = 2,
            max_attempts = 3,
            debounce = 200, ---@type integer | false
            auto_refresh = { backward = false, forward = true },
          },
        },
      },
    },
    fuzzy = {
      implementation = 'lua',
      -- implementation = 'prefer_rust_with_warning',
      max_typos = 3,
      frecency = {
        enabled = false,
        path = vim.fn.stdpath('state') .. '/blink/cmp/frecency.dat',
        unsafe_no_lock = false,
      },
      -- Proximity bonus boosts the score of items matching nearby words
      -- Note, this does not apply when using the Lua implementation.
      use_proximity = false,

      -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
      -- You may pass a function instead of a string to customize the sorting
      sorts = {
        -- (optionally) always prioritize exact matches
        -- 'exact',

        -- pass a function for custom behavior
        -- function(item_a, item_b)
        --   return item_a.score > item_b.score
        -- end,

        'score',
        'sort_text',
      },
      prebuilt_binaries = { download = false },
    },
  },
  opts_extend = { 'sources.default' },
}
