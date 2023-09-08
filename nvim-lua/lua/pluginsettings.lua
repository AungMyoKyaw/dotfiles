local vimp = require('vimp')
local g = vim.g
local opt = vim.o

-- Theme
require('catppuccin').setup({
  flavour = 'mocha', -- latte, frappe, macchiato, mocha
  integrations = {
    cmp = true,
    gitsigns = true,
    mason = true,
    nvimtree = true,
    treesitter = true,
    treesitter_context = true,
    vimwiki = true,
    which_key = true
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  }
})
-- setup must be called before loading
vim.cmd.colorscheme 'catppuccin'

vim.cmd [[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]]
vim.cmd [[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]]

----------
-- which key
require('which-key').setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

-- start nvim colorizer lua
require('colorizer').setup()

-- vim.cmd [[call FlutterMenu()]]

-- require("focus").setup()

-- nvim tree setup
require('nvim-tree').setup {renderer = {highlight_opened_files = 'all'}}
-- vim.cmd [[autocmd Colorscheme * highlight NvimTreeNormal guibg=none guifg=#9da5b3]]
-- vimp.nnoremap('<C-n>', [[:e .<CR>]])
vimp.nnoremap('<C-n>', [[:NvimTreeToggle<CR>]])

-- gitsigns
local gitsigns = require('gitsigns')
gitsigns.setup()

-- fterm
local fterm = require('FTerm')
vimp.nnoremap('<leader>ft', fterm.toggle)

-- status line setup
require('lualine').setup {
  options = {
    theme = 'catppuccin',
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    section_separators = {left = '', right = ''},
    component_separators = {left = '', right = ''}
  }
}

local configure_language = require('kommentary.config').configure_language
configure_language('nim', {
  single_line_comment_string = '#',
  multi_line_comment_strings = {'#[', ']#'},
  prefer_single_line_comments = true
})

require('kommentary.config').configure_language('typescriptreact', {
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
  hook_function = function()
    require('ts_context_commentstring.internal').update_commentstring()
  end
})

require('kommentary.config').configure_language('svelte', {
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
  hook_function = function()
    require('ts_context_commentstring.internal').update_commentstring()
  end
})

configure_language('default', {prefer_single_line_comments = true})

-- no more bufferline
opt.showtabline = 0

-- macvim  conf
opt.background = 'dark'
-- opt.guifont = "FiraCode Nerd Font Mono:h25"

-- vim easy align
-- Start interactive EasyAlign in visual mode (e.g. vipga)
vimp.xmap('ga', '<Plug>(EasyAlign)')

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vimp.nmap('ga', '<Plug>(EasyAlign)')

-- easy motion
vimp.nmap('<Leader><Leader>f', '<Plug>(easymotion-overwin-f)')

-- s{char}{char} to move to {char}{char}
vimp.nmap('s', '<Plug>(easymotion-overwin-f2)')

-- Move to line
vimp.nmap('<Leader><Leader>L', '<Plug>(easymotion-overwin-line)')

-- " Move to word
vimp.nmap('<Leader><Leader>w', '<Plug>(easymotion-overwin-w)')

-- " Turn on case-insensitive feature
g.EasyMotion_smartcase = 1

-- js-docs
g.jsdoc_allow_input_prompt = 1
g.jsdoc_enable_es6 = 1
g.jsdoc_input_description = 1

-- neogen
local neogen = require('neogen')
neogen.setup({snippet_engine = 'luasnip'})
vimp.nnoremap('<Leader>nf', [[:lua require('neogen').generate()<CR>]])

-- fzf
vimp.nnoremap('<C-p>', [[:Files<CR>]])
vimp.nnoremap('<leader>ff', [[:Files<CR>]])
vimp.nnoremap('<leader>fg', [[:Rg<CR>]])
vimp.nnoremap('<leader>fc', [[:Commands<CR>]])

-- ctrlsf
-- vimp.nmap('<C-F>f', '<Plug>CtrlSFPrompt')
-- vimp.vmap('<C-F>f', '<Plug>CtrlSFVwordPath')
-- vimp.vmap('<C-F>F', '<Plug>CtrlSFVwordExec')
-- vimp.nmap('<C-F>n', '<Plug>CtrlSFCwordPath')
-- vimp.nmap('<C-F>p', '<Plug>CtrlSFPwordPath')
-- vimp.nnoremap('<C-F>o', ':CtrlSFOpen<CR>')
-- vimp.nnoremap('<C-F>t', ':CtrlSFToggle<CR>')
-- vimp.inoremap('<C-F>t', '<Esc>:CtrlSFToggle<CR>')

vimp.nmap('<C-F>f', '<cmd>lua require("spectre").open()<CR>')
-- vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
--     desc = "Search current word"
-- })
-- vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
--     desc = "Search current word"
-- })
-- vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
--     desc = "Search on current file"
-- })

-- ----------------------------------------------------------------------------------------------------
-- VIM WIKI
-- ----------------------------------------------------------------------------------------------------
g.vimwiki_global_ext = 0
local mywiki = {}
mywiki.path = '/Users/aungmyokyaw/MEGAsync/aungmyokyaw/MyWiki'
mywiki.syntax = 'markdown'
mywiki.ext = '.md'
g.vimwiki_list = {mywiki}
g.vimwiki_folding = 'expr'
-- stop stealing tab in vim wiki and enable auto completion
g.vimwiki_key_mappings = {table_mappings = 0, table_format_mappings = 0}
-- don't conceal link
g.vimwiki_conceallevel = 0

-- vim rest setting
g.vrc_curl_opts = {}
g.vrc_curl_opts['-i'] = ''

-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  -- ensure_installed = {
  --   'help', 'javascript', 'typescript', 'c', 'lua', 'rust', 'svelte', 'vim',
  --   'css', 'html', 'json', 'markdown'
  -- },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then return true end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your esditor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    -- additional_vim_regex_highlighting = {"nim"}
    -- JoosepAlviste/nvim-ts-context-commentstring setting
    context_commentstring = {enable = true, enable_autocmd = false}
  }
}

------------------------------
-- code formatter
-- Utilities for creating configurations
local util = require 'formatter.util'

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require('formatter').setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    lua = {
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == 'special.lua' then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = 'lua-format',
          args = {
            '--indent-width=2', '--column-limit=80', '--no-use-tab',
            '--double-quote-to-single-quote',
            util.escape_path(util.get_current_buffer_file_path())
          },
          stdin = true
        }
      end
    },

    js = {
      function()
        return {
          exe = 'prettierd',
          args = {'--stdin-filepath', util.get_current_buffer_file_name()},
          stdin = true
        }
      end
    },

    html = {
      function()
        return {
          exe = 'prettierd',
          args = {'--stdin-filepath', util.get_current_buffer_file_name()},
          stdin = true
        }
      end
    },

    css = {
      function()
        return {
          exe = 'prettierd',
          args = {'--stdin-filepath', util.get_current_buffer_file_name()},
          stdin = true
        }
      end
    },

    ts = {
      function()
        return {
          exe = 'prettierd',
          args = {'--stdin-filepath', util.get_current_buffer_file_name()},
          stdin = true
        }
      end
    },

    json = {
      function()
        return {
          exe = 'prettierd',
          args = {'--stdin-filepath', util.get_current_buffer_file_name()},
          stdin = true
        }
      end
    },

    python = {function() return {exe = 'yapf', stdin = true} end},

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ['*'] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require('formatter.filetypes.any').remove_trailing_whitespace
    }
  }
}

-- config for fzf vim
g.fzf_vim = {}
g.fzf_buffers_jump = 1
-- g.fzf_preview_window = {'hidden,right,50%,<70(up,40%)', 'ctrl-/'}
g.fzf_preview_window = {'hidden', 'ctrl-/'}
g.fzf_buffers_sort = 'mru'
g.fzf_layout = {window = {width = 0.9, height = 0.9}}
