" Automatically install Plug on request, if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Plugins
call plug#begin('~/.vim/plugged')

"LSP server
Plug 'neovim/nvim-lspconfig'

"C++ highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
"fish script highlighting
Plug 'dag/vim-fish'

"Auto complete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

"mypy
Plug 'flebel/vim-mypy', {'branch': 'bugfix/fast_parser_is_default_and_only_parser'}

"GUI enhancements
Plug 'itchyny/lightline.vim'

" Vim tmux navigator
Plug 'christoomey/vim-tmux-navigator'

" Python folding
Plug 'tmhedberg/SimpylFold'

" Vimtex
Plug 'lervag/vimtex'

call plug#end()


"Colour scheme
"colorscheme slate

"Set line numbers
set number

"Max line length marker
set colorcolumn=83
highlight ColorColumn ctermbg=247

"Set all tabs to spaces
set expandtab

"Set size of indent
set shiftwidth=4

set smarttab

"Folding
set foldmethod=syntax
nnoremap <Space> za
nnoremap <C-Space> zA

"Turn off arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"Spellchecker toggle
map <C-s> :setlocal spell! spelllang=en_gb<CR>

"Remove trailing white spaces
"autocmd BufWritePre * %s/\s\+$//e

" Show line diagnostics in pop out window and navigate between them
nnoremap <silent> g? <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <C-j> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
"nnoremap <silent> <space>d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

" File explorer
let g:netrw_banner = 0
"let g:netrw_winsize = 25

"" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" Autocompletion with hrsh7th/nvim-cmp
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-y>'] = cmp.config.disable,
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. Set `select` to `false` to only confirm
      -- explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      -- Tab through different options
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`,
  -- this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pylsp'].setup {
    capabilities = capabilities
  }
EOF

" Vimtex

" This is necessary for VimTeX to load properly. The indent is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see \":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
" let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
" let g:vimtex_view_general_viewer = 'okular'
" let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see \":help vimtex-compiler".
" let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol \"\".
" let maplocalleader = ","
