-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:

local keymap = vim.keymap

return {
  { 'nvim-telescope/telescope-file-browser.nvim', lazy = true },
  { 'nvim-telescope/telescope-ui-select.nvim', lazy = true },
  { 'nvim-telescope/telescope-frecency.nvim', lazy = true },
  { 'Allianaab2m/telescope-kensaku.nvim', lazy = true, dependencies = { 'lambdalisue/kensaku.vim' } },
  { -- {@@2 tiny-code-action
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
    keys = {
      {
        'gla',
        function()
          require('tiny-code-action').code_action()
        end,
        mode = { 'n' },
        desc = 'Tiny code action',
      },
    },

    opts = {
      telescope_opts = {
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.7,
          height = 0.9,
          preview_cutoff = 1,
          preview_height = function(_, _, max_lines)
            local h = math.floor(max_lines * 0.5)
            return math.max(h, 10)
          end,
        },
      },
    },
  }, -- @@}
  { -- {@@1 telescope
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope', 'Z' },
    keys = { '<Leader>', 'gl' },
    dependencies = { 'plenary.nvim', 'mini.icons' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local builtin = require('telescope.builtin')
      local fb_actions = telescope.extensions.file_browser.actions

      ---@desc Setup {@@2
      telescope.setup({
        defaults = { ---{@@3
          path_display = { truncate = 1 },
          winblend = vim.g.tr_bg and 0 or 10,
          previewer = false,
          cache_picker = false,
          color_devicons = true,
          file_ignore_patterns = { -- {@@4
            'lazy-lock.json',
            '^%.obsidian[/\\]',
            '^%.trash[/\\]',
            '^%.git[/\\]',
            '^%.bundle[/\\]',
            '[/\\]%.git[/\\]',
            '[/\\]%.bundle[/\\]',
            'node_modules[/\\]',
            'vendor[/\\]',
            'migemo[/\\]',
          }, -- @@}
          prompt_title = false,
          prompt_prefix = ' ',
          selection_caret = ' ',
          -- multi_icon = " ",
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            -- anchor = "S",
            preview_cutoff = 1,
            prompt_position = 'top',
            height = 0.7,
            width = 0.7,
          },
          vimgrep_arguments = { -- {@@4
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim',
            '--glob=!{node_modules,vendor,migemo,.bundle,.git}/',
          }, -- @@}
          mappings = { -- {@@4
            i = {
              ['<C-l>'] = { '<Plug>(skkeleton-enable)', type = 'command' },
              ['<C-s>'] = actions.file_split,
              ['<C-k>'] = actions.preview_scrolling_up,
              ['<C-j>'] = actions.preview_scrolling_down,
              ['<C-g>'] = actions.close,
              ['<C-a>'] = { '<Home>', type = 'command' },
              ['<C-e>'] = { '<End>', type = 'command' },
              ['<C-d>'] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                if current_picker.prompt_title == 'Most Recently Use' then
                  local filename = action_state.get_selected_entry()[1]
                  current_picker:remove_selection(current_picker:get_selection_row())
                  vim.notify(string.format('[mru] cache deleted "%s"', filename), 3)
                  vim.fn['mr#mru#delete'](filename)
                end
              end,
            },
            n = {
              ['<C-g>'] = actions.close,
            },
          }, -- @@}
        }, ---@@}
        pickers = { -- {@@3
          buffers = {
            sort_mru = true,
            mappings = { i = { ['<C-D>'] = actions.delete_buffer } },
          },
          live_grep = {
            max_results = 100,
            disable_coordinates = true,
          },
          current_buffer_fuzzy_find = {
            skip_empty_lines = true,
          },
          git_bcommits = {
            mappings = {
              i = {
                ['<C-x>'] = function(bufnr)
                  local hash = action_state.get_selected_entry().value
                  vim.schedule(function()
                    vim.cmd('MugDiff bottom ' .. hash)
                  end)
                  return actions.close(bufnr)
                end,
                ['<C-v>'] = function(bufnr)
                  local hash = action_state.get_selected_entry().value
                  vim.schedule(function()
                    vim.cmd('MugDiff right ' .. hash)
                  end)
                  return actions.close(bufnr)
                end,
              },
            },
          },
        }, -- @@}
        extensions = { -- {@@3
          file_browser = {
            grouped = true,
            hidden = { file_browser = true, folder_browser = true },
            respect_gitignore = false,
            follow_symlinks = false,
            -- quiet = false,
            -- dir_icon = '',
            dir_icon_hl = 'Directory',
            display_stat = false,
            use_fd = true,
            git_status = false,
            prompt_path = true,
            mappings = {
              ['i'] = {
                ['<C-h>'] = fb_actions.goto_parent_dir,
                ['<C-t>'] = actions.file_tab,
                ['<C-k>'] = actions.preview_scrolling_up,
                ['<C-j>'] = actions.preview_scrolling_down,
              },
              ['n'] = {},
            },
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({
              -- even more opts
            }),
          },
          frecency = {
            ignore_patterns = { '*/.git', '*/.git/*', [[*.git\*]], [[*\tmp\]], 'term://*', 'MugTerm://*', '*.jax' },
            db_safe_mode = false,
            auto_validate = true,
            db_validate_threshold = 5,
            matcher = 'fuzzy',
          },
        }, -- @@}
      })
      telescope.load_extension('file_browser')
      telescope.load_extension('ui-select')
      telescope.load_extension('kensaku')
      telescope.load_extension('frecency')

      ---@desc Previewer {@@2
      local preview = { -- {@@3
        no = {
          results_title = false,
          previewer = false,
          layout_config = { height = 0.7, width = 0.6 },
        },
        hor = {
          previewer = true,
          layout_config = {
            anchor = 'N',
            preview_cutoff = 1,
            prompt_position = 'top',
            height = 0.3,
            width = 0.6,
          },
          path_display = function(_, path)
            return string.format('%s', path)
          end,
        },
        vert = {
          -- winblend = 9,
          results_title = false,
          path_display = function(_, path)
            return string.format('%s ', path)
          end,
        },
      } -- @@}
      local instance = function(type, add) -- {@@3
        local opts = vim.tbl_deep_extend('force', preview[type], add)
        return setmetatable(opts, {
          __index = {
            new = function(self)
              return type == 'vert' and self or require('telescope.themes').get_dropdown(self)
            end,
          },
        })
      end -- @@}
      local function load_builtin(picker, type, add) -- {@@3
        local previewer = instance(type, add)
        builtin[picker](previewer:new())
      end -- @@}
      local function load_ext(picker, type, add) -- {@@3
        local previewer = instance(type, add)
        require('telescope').extensions[picker][picker](previewer:new())
      end -- @@}

      ---@desc Keymap {@@2
      local function is_repo() --{@@3
        local has_root = true
        local name = vim.b.mug_branch_name
        ---@diagnostic disable-next-line: undefined-field
        if name == _G.Mug.symbol_not_repository then
          has_root = false
          vim.notify('Not repository', vim.log.levels.INFO)
        end
        return has_root
      end --@@}3
      -- keymap.del('c', '<Plug>(TelescopeFuzzyCommandSearch)')
      -- keymap.set('n', '<Leader>:', function()
      --   load_builtin('buffers', 'no', { ignore_current_buffer = true })
      -- end, {})
      -- keymap.set('n', '<leader>m', function()
      --   load_ext('frecency', 'no', {})
      -- end, {})
      -- keymap.set('n', '<leader>p', function()
      --   local path = vim.fn.expand('%:h:p')
      --   load_ext('file_browser', 'no', { path = path })
      -- end, {})
      -- keymap.set('n', '<leader>o', function()
      --   load_builtin('find_files', 'no', { hidden = true, no_ignore = true })
      -- end, {})
      keymap.set('n', '<leader>k', function()
        local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
        load_ext('kensaku', 'hor', { cwd = path })
      end, {})
      keymap.set('n', '<leader>K', function()
        load_ext('kensaku', 'hor', {})
      end, {})
      -- keymap.set('n', '<leader>h', function()
      --   local slash = vim.o.shellslash
      --   vim.o.shellslash = false
      --   load_builtin('help_tags', 'vert', { layout_config = { preview_width = 0.7, width = 0.8, height = 0.9 } })
      --   vim.o.shellslash = slash
      -- end, {})
      -- keymap.set('n', '<leader>l', function()
      --   load_builtin(
      --     'current_buffer_fuzzy_find',
      --     'vert',
      --     { layout_config = { preview_width = 0.5, width = 0.9, height = 0.9 }, results_ts_highlight = false }
      --   )
      -- end, {})
      keymap.set('n', '<Leader>gb', function()
        if is_repo() then
          load_builtin('git_branches', 'hor', {})
        end
      end, {})
      local commit_cmd = { 'git', 'log', '-20', '--date=short', '--format=%h [%ad] %s%d', '--', '.' }
      keymap.set('n', '<Leader>gC', function()
        if is_repo() then
          load_builtin('git_commits', 'vert', {
            git_command = commit_cmd,
            layout_config = { mirror = false, preview_width = 0.55, width = 0.9, height = 0.9 },
          })
        end
      end, {})
      keymap.set('n', '<Leader>gc', function()
        if is_repo() then
          load_builtin('git_bcommits', 'vert', {
            git_command = commit_cmd,
            layout_config = { mirror = false, preview_width = 0.55, width = 0.9, height = 0.9 },
          })
        end
      end, {})

      ---@desc Usercommand "Z <filepath>" zoxide query {@@
      vim.api.nvim_create_user_command('Z', function(opts)
        vim.system({ 'zoxide', 'query', opts.args }, { text = true }, function(data)
          vim.schedule(function()
            if data.code == 0 and data.stdout then
              local path = data.stdout:gsub('\n', '')
              load_ext('file_browser', 'no', { path = path })
            else
              vim.notify('[zoxide] no match found', 3)
            end
          end)
        end)
      end, { nargs = 1 })
    end,
  }, --@@}1
}
