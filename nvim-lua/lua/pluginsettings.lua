local vimp       = require('vimp')
local gitsigns   = require('gitsigns')
local bufferline = require('bufferline')
local g          = vim.g
local opt        = vim.o

-- themes
g.material_style              = "deep ocean"
g.material_italic_comments    = true
g.material_italic_keywords    = true
g.material_italic_functions   = true
g.material_italic_variables   = false
g.material_contrast           = true
g.material_borders            = true
g.material_disable_background = false
require('material').set()

g.dashboard_default_executive ='telescope'

-- gitsigns
gitsigns.setup()

-- fterm
require("FTerm").setup()
vimp.nmap('<leader>ft',"<cmd>lua require('FTerm').toggle()<cr>")

-- status line setup
require('lualine').setup{
    options = {theme = 'material'}
}

local configure_language = require('kommentary.config').configure_language
configure_language("nim", {
    single_line_comment_string = "#",
    multi_line_comment_strings = {"#[", "]#"},
    prefer_single_line_comments = true,
})
configure_language("default", {
    prefer_single_line_comments = true,
})

-- Themes
opt.showtabline=2
bufferline.setup{}

-- macvim  conf
opt.background = "dark"
opt.guifont    = "FiraCode Nerd Font Mono:h25"

-- vim easy align
-- Start interactive EasyAlign in visual mode (e.g. vipga)
vimp.xmap('ga','<Plug>(EasyAlign)')

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vimp.nmap('ga','<Plug>(EasyAlign)')


-- easy motion
vimp.nmap('<Leader><Leader>f','<Plug>(easymotion-overwin-f)')

-- s{char}{char} to move to {char}{char}
vimp.nmap('s','<Plug>(easymotion-overwin-f2)')

-- Move to line
vimp.nmap('<Leader><Leader>L','<Plug>(easymotion-overwin-line)')

-- " Move to word
vimp.nmap('<Leader><Leader>w','<Plug>(easymotion-overwin-w)')

-- " Turn on case-insensitive feature
g.EasyMotion_smartcase = 1

-- js-docs
g.jsdoc_allow_input_prompt = 1
g.jsdoc_enable_es6         = 1
g.jsdoc_input_description  = 1

-- CtrlP
-- vimp.nmap('<C-p>',"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({}))<cr>")
vimp.nmap('<C-p>',"<cmd>lua require('telescope.builtin').find_files()<cr>")
vimp.nmap('<leader>ff',"<cmd>lua require('telescope.builtin').find_files()<cr>")

-- " ALE Settings
g.ale_fixers                               = {'prettier', 'eslint', 'trim_whitespace'}
g.ale_javascript_prettier_options          = '--single-quote --trailing-comma none'
g.ale_javascript_prettier_use_local_config = 1
g.ale_disable_lsp                          = 1
-- " let g:ale_completion_enabled                   = 1
-- " let g:ale_completion_autoimport                = 1
-- " let g:ale_hover_cursor                         = 1
-- " let g:ale_fix_on_save                          = 1

-- ctrlsf
vimp.nnoremap('<C-F>f',"<cmd>lua require('telescope.builtin').live_grep()<cr>")
vimp.nnoremap('<leader>fg',"<cmd>lua require('telescope.builtin').live_grep()<cr>")

-- telescope commands
vimp.nnoremap('<leader>fc',"<cmd>lua require('telescope.builtin').commands()<cr>")

-- " nvim-Tree
vimp.nnoremap('<C-n>',[[:NvimTreeToggle<cr>]])

-- ----------------------------------------------------------------------------------------------------
-- VIM WIKI
-- ----------------------------------------------------------------------------------------------------
g.vimwiki_global_ext = 0
local mywiki         = {}
mywiki.path          = '~/Dropbox/MyWiki/'
mywiki.syntax        = 'markdown'
mywiki.ext           = '.md'
g.vimwiki_list       = {mywiki}
g.vimwiki_folding    = 'expr'

-- vim rest setting
g.vrc_curl_opts       = {}
g.vrc_curl_opts['-i'] = ''

-- " vim polyglot
g.vim_markdown_conceal             = 0
g.vim_markdown_conceal_code_blocks = 0

-- " ----------------------------------------------------------------------------------------------------
-- " COC VIM
-- " ----------------------------------------------------------------------------------------------------
g.coc_global_extensions = {'coc-snippets', 'coc-json', 'coc-git', 'coc-rome'}

-- " TextEdit might fail if hidden is not set.
opt.hidden=true

-- " Some servers have issues with backup files, see #649.
-- set nobackup
-- set nowritebackup

-- " Give more space for displaying messages.
-- set cmdheight=2

-- " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- " delays and poor user experience.
-- set updatetime=300

-- " Don't pass messages to |ins-completion-menu|.
-- set shortmess+=c

-- " Always show the signcolumn, otherwise it would shift the text each time
-- " diagnostics appear/become resolved.
-- if has("patch-8.1.1564")
--   " Recently vim can merge signcolumn and number column into one
--   set signcolumn=number
-- else
--   set signcolumn=yes
-- endif

-- " Use tab for trigger completion with characters ahead and navigate.
-- " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- " other plugin before putting this into your config.
-- inoremap <silent><expr> <TAB>
--       \ pumvisible() ? "\<C-n>" :
--       \ <SID>check_back_space() ? "\<TAB>" :
--       \ coc#refresh()
-- inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

-- function! s:check_back_space() abort
--   let col = col('.') - 1
--   return !col || getline('.')[col - 1]  =~# '\s'
-- endfunction

-- " Use <c-space> to trigger completion.
-- if has('nvim')
--   inoremap <silent><expr> <c-space> coc#refresh()
-- else
--   inoremap <silent><expr> <c-@> coc#refresh()
-- endif

-- " Make <CR> auto-select the first completion item and notify coc.nvim to
-- " format on enter, <cr> could be remapped by other vim plugin
-- inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
--                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

-- " Use `[g` and `]g` to navigate diagnostics
-- " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
-- nmap <silent> [g <Plug>(coc-diagnostic-prev)
-- nmap <silent> ]g <Plug>(coc-diagnostic-next)

-- " GoTo code navigation.
-- nmap <silent> gd <Plug>(coc-definition)
-- nmap <silent> gy <Plug>(coc-type-definition)
-- nmap <silent> gi <Plug>(coc-implementation)
-- nmap <silent> gr <Plug>(coc-references)

-- " Use K to show documentation in preview window.
-- nnoremap <silent> K :call <SID>show_documentation()<CR>

-- function! s:show_documentation()
--   if (index(['vim','help'], &filetype) >= 0)
--     execute 'h '.expand('<cword>')
--   elseif (coc#rpc#ready())
--     call CocActionAsync('doHover')
--   else
--     execute '!' . &keywordprg . " " . expand('<cword>')
--   endif
-- endfunction

-- " Highlight the symbol and its references when holding the cursor.
-- autocmd CursorHold * silent call CocActionAsync('highlight')

-- " Symbol renaming.
-- nmap <leader>rn <Plug>(coc-rename)

-- " Formatting selected code.
-- xmap <leader>f  <Plug>(coc-format-selected)
-- nmap <leader>f  <Plug>(coc-format-selected)

-- augroup mygroup
--   autocmd!
--   " Setup formatexpr specified filetype(s).
--   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
--   " Update signature help on jump placeholder.
--   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
-- augroup end

-- " Applying codeAction to the selected region.
-- " Example: `<leader>aap` for current paragraph
-- xmap <leader>a  <Plug>(coc-codeaction-selected)
-- nmap <leader>a  <Plug>(coc-codeaction-selected)

-- " Remap keys for applying codeAction to the current buffer.
-- nmap <leader>ac  <Plug>(coc-codeaction)
-- " Apply AutoFix to problem on the current line.
-- nmap <leader>qf  <Plug>(coc-fix-current)

-- " Map function and class text objects
-- " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
-- xmap if <Plug>(coc-funcobj-i)
-- omap if <Plug>(coc-funcobj-i)
-- xmap af <Plug>(coc-funcobj-a)
-- omap af <Plug>(coc-funcobj-a)
-- xmap ic <Plug>(coc-classobj-i)
-- omap ic <Plug>(coc-classobj-i)
-- xmap ac <Plug>(coc-classobj-a)
-- omap ac <Plug>(coc-classobj-a)

-- " Remap <C-f> and <C-b> for scroll float windows/popups.
-- " if has('nvim-0.4.0') || has('patch-8.2.0750')
-- "   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
-- "   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
-- "   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
-- "   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
-- "   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
-- "   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
-- " endif

-- " NeoVim-only mapping for visual mode scroll
-- " Useful on signatureHelp after jump placeholder of snippet expansion
-- " if has('nvim')
-- "   vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
-- "   vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
-- " endif

-- " Use CTRL-S for selections ranges.
-- " Requires 'textDocument/selectionRange' support of language server.
-- " nmap <silent> <C-s> <Plug>(coc-range-select)
-- " xmap <silent> <C-s> <Plug>(coc-range-select)

-- " Add `:Format` command to format current buffer.
-- command! -nargs=0 Format :call CocAction('format')

-- " Add `:Fold` command to fold current buffer.
-- command! -nargs=? Fold :call     CocAction('fold', <f-args>)

-- " Add `:OR` command for organize imports of the current buffer.
-- command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

-- " Add (Neo)Vim's native statusline support.
-- " NOTE: Please see `:h coc-status` for integrations with external plugins that
-- " provide custom statusline: lightline.vim, vim-airline.
-- set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

-- " Mappings for CoCList
-- " Show all diagnostics.
-- nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
-- " Manage extensions.
-- nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
-- " Show commands.
-- nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
-- " Find symbol of current document.
-- nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
-- " Search workspace symbols.
-- nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
-- " Do default action for next item.
-- nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
-- " Do default action for previous item.
-- nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
-- " Resume latest coc list.
-- nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
