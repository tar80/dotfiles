-- vim:textwidth=0:foldmethod=marker:foldlevel=2:
--------------------------------------------------------------------------------

local use_model = {
  name = 'gemini',
  model = 'gemini-2.0-flash',
}

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'plenary.nvim',
    'nvim-treesitter',
    'mini.diff',
    'blink.cmp',
  },
  cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanionCmd' },
  keys = {
    { ';ca', ':CodeCompanionChat Add<CR>', mode = { 'v' }, desc = 'CodeCompanion Add selection' },
    { ';cc', ':CodeCompanionChat Toggle<CR>', desc = 'CodeCompanion Toggle Chat' },
    { ';cr', '<Cmd>CodeCompanion /refactor<CR>', mode = { 'v' }, desc = 'CodeCompanion Refactor selection' },
    -- { 'me', '<Cmd>CodeCompanion /explain<CR>', mode = { 'v' }, desc = 'CodeCompanion Explain selection' },
    -- { 'mf', '<Cmd>CodeCompanion /fix<CR>', mode = { 'v' }, desc = 'CodeCompanion Fix selection' },
    -- { 'mt', '<Cmd>CodeCompanion /tests<CR>', mode = { 'v' }, desc = 'CodeCompanion Test selection' },
  },
  init = require('plugin.source.codecompanion_spinner'):init(),
  opts = {
    opts = {
      language = 'Japanese',
      log_level = 'ERROR',
    },
    adapters = {
      http = {
        opts = {
          show_defaults = false,
        },
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = vim.env.GEMINI_API_KEY,
            },
          })
        end,
      },
    },
    display = {
      chat = {
        auto_scroll = false,
        fold_context = false,
        intro_message = '...󰙏',
        show_header_separator = false,
        separator = '',
        -- show_references = true,
        show_settings = false,
        show_token_count = true,
        start_in_insert_mode = false,
        window = {
          width = 0.4,
        },
      },
      action_palette = {
        width = 95,
        height = 10,
        prompt = 'Prompt ',
        provider = 'default',
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
          title = 'CodeCompanion actions',
        },
      },
      diff = {
        enabled = true,
        provider = 'inline', -- mini_diff|split|inline
        provider_opts = {
          inline = {
            layout = 'buffer',
            diff_signs = {
              signs = {
                text = '▌', -- Sign text for normal changes
                reject = '✗', -- Sign text for rejected changes in super_diff
                highlight_groups = {
                  addition = 'DiagnosticOk',
                  deletion = 'DiagnosticError',
                  modification = 'DiagnosticWarn',
                },
              },
              icons = {
                accepted = ' ',
                rejected = ' ',
              },
              colors = {
                accepted = 'DiagnosticOk',
                rejected = 'DiagnosticError',
              },
            },

            opts = {
              context_lines = 3, -- Number of context lines in hunks
              dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
              full_width_removed = true, -- Make removed lines span full width
              show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
              show_removed = true, -- Show removed lines as virtual text
            },
          },
          split = {
            close_chat_at = 100,
            layout = 'vertical',
            opts = {
              'internal',
              'filler',
              'closeoff',
              'algorithm:histogram',
              'indent-heuristic',
              'followwrap',
              'linematch:120',
            },
          },
        },
      },
    },
    strategies = {
      agent = {
        adapter = 'gemini',
      },
      inline = {
        adapter = use_model,
      },
      cmd = {
        adapter = use_model,
      },
      chat = {
        adapter = use_model,
        opts = {
          completion_provider = 'blink',
        },
        roles = {
          llm = function(adapter)
            return '󰙴 ' .. adapter.formatted_name
          end,
          user = '󰹽 User',
        },
        keymaps = {
          send = {
            modes = { n = '<C-CR>', i = '<C-CR>' },
            callback = function(chat)
              vim.cmd('stopinsert')
              vim.api.nvim_input('zt')
              chat:submit()
              chat:add_buf_message({ role = 'llm', content = '' })
            end,
            index = 1,
            description = 'Send message',
          },
        },
        slash_commands = {
          ['buffer'] = {
            keymaps = {
              modes = {
                i = '<C-s>',
                n = { '<C-s>' },
              },
            },
          },
        },
        tools = {
          groups = {
            ['files'] = {
              opts = {
                collapse_tools = false, -- Shows all tools in the group as individual references
              },
            },
          },
        },
      },
    },
    prompt_library = {
      ['Refactoring'] = {
        strategy = 'chat',
        description = 'Refactor the selected code',
        opts = {
          index = 0,
          is_default = true,
          is_slash_cmd = false,
          modes = { 'v' },
          short_name = 'refactor',
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = 'system',
            content = [[When asked to refactor code, follow these steps:

1.  **Understand the Code**: Carefully read the provided code and understand its functionality and structure.
2.  **Identify Improvements**: Identify improvements to enhance the code's readability, maintainability, and efficiency. For example, look for duplicated code, overly complex functions, inappropriate naming, etc.
3.  **Refactoring Plan**: Describe the plan for refactoring the code in pseudocode, detailing each step.
4.  **Implement Refactoring**: Write the refactored code in a single code block.
5.  **Explain Changes**: Briefly explain what changes were made and why.

Ensure the refactored code:

-   Maintains its original functionality.
-   Improves readability and maintainability.
-   Eliminates code duplication.
-   Uses appropriate naming conventions.
-   Is formatted correctly.

Use Markdown formatting and include the programming language name at the start of the code block.]],
            opts = {
              visible = false,
            },
          },
          {
            role = 'user',
            content = function(context)
              local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

              return string.format(
                [[Please Refactoring this code from buffer %d:

```%s
%s
```
]],
                context.bufnr,
                context.filetype,
                code
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },
  },
}
