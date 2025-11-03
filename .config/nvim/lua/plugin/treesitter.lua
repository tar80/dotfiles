local filetypes = { 'lua', 'javascript', 'typescript', 'json', 'diff', 'markdown', 'vim' }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    branch = 'main',
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    opts = {
      install_dir = vim.fn.stdpath('data') .. '/site',
    },
    config = function()
      vim.g._ts_force_sync_parsing = false

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    branch = 'main',
    opts = {
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@conditional.outer'] = 'V', -- linewise
          ['@function.outer'] = 'V', -- linewise
          ['@loop.outer'] = 'V', -- linewise
        },
        include_surrounding_whitespace = false,
      },
    },
    keys = {
      {
        'am',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Select around function',
      },
      {
        'im',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Select inside function',
      },
      {
        'ai',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Select around conditional',
      },
      {
        'ii',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Select inside conditional',
      },
      {
        'al',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Select around loop',
      },
      {
        'il',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Select inside loop',
      },
      {
        ']m',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Next function start',
      },
      {
        ']M',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Next function end',
      },
      {
        '[m',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Previous function start',
      },
      {
        '[M',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Previous function end',
      },
      {
        ']i',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@conditional.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Next conditional start',
      },
      {
        ']I',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@conditional.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Next conditional end',
      },
      {
        '[i',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@conditional.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Previous conditional start',
      },
      {
        '[I',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@conditional.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Previous conditional end',
      },
      {
        ']l',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@loop.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Next loop start',
      },
      {
        ']L',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@loop.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Next loop end',
      },
      {
        '[l',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@loop.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Previous loop start',
      },
      {
        '[L',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@loop.outer', 'textobjects')
        end,
        mode = 'n',
        desc = 'Previous loop end',
      },
      {
        '<C-k>',
        function()
          require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
        end,
        mode = 'n',
        desc = 'Swap next parameter',
      },
      {
        '<C-j>',
        function()
          require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
        end,
        mode = 'n',
        desc = 'Swap previous parameter',
      },
    },
  },
}
