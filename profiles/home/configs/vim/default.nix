{ pkgs
, config
, lib
, ...
}:
let
  vim-zettel =  pkgs.vimUtils.buildVimPlugin {
    name = "vim-zettel";
    src = pkgs.fetchFromGitHub {
      owner = "michal-h21";
      repo = "vim-zettel";
      rev = "86a5009a0009ee407c189266edcf9a1e9ee618df";
      sha256 = "mmS++H3xyhuiA16NWbDiGQfoTzEqSK9PMTFhdy+3jDo=";
    };
  };
in
{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      fzf-vim
      vim-better-whitespace
      vim-highlightedyank
      vim-colorschemes
      vim-commentary
      palenight-vim
      lightline-vim
      vim-gitbranch
      vim-smoothie
      vim-polyglot
      vim-elixir
      auto-pairs
      emmet-vim
      coc-pairs
      rust-vim
      nerdtree
      coc-nvim
      vimwiki
      vim-nix

      vim-zettel
    ];

    extraConfig = ''
      " --------------- settings ------------------

      " set leader key
      let g:mapleader = " "

      " Syntax highlighting
      syntax on

      " colorscheme
      set background=dark
      colorscheme palenight

      " Position in code
      " shows the real line number aswell
      set number
      set rnu
      set ruler

      " deactivate Insert in statusline
      set noshowmode

      " default file encoding
      set encoding=utf-8

      " Line wrap
      set wrap

      set laststatus=2

      " Highlight search results
      set hlsearch
      set incsearch
      " case search
      set ignorecase
      set smartcase

      " auto + smart indent for code
      set autoindent
      set smartindent

      set t_Co=256

      " Mouse support
      set mouse=a

      " disable backup files
      set nobackup
      set nowritebackup

      " Fix backspace indent
      set backspace=indent,eol,start

      " no delays
      set updatetime=300

      " split windows below and right
      set splitbelow
      set splitright

      " set wildignores
      set wildignore+=*.o,*.so,*.dll,*.a,*.vi,*.exe,*.cd,*.obj
      set wildignore+=*.ko,tags
      set wildignore+=*.sln,*.vcproj,*.vspscc,*.dsw,*.dsp
      set wildignore+=*.png,*.pdf,*.bmp,*.jpg,*.jpeg,*.gif
      set wildignore+=*.dtb,*.dtbo

      set cmdheight=1
      set shortmess+=c

      set hidden

      set title

      set signcolumn=yes

      " --------------- costum keymaps ------------------

      " esc is far far away
      :imap jj <Esc>

      " moving between panes
      map <C-j> <C-w>j
      map <C-k> <C-w>k
      map <C-l> <C-w>l
      map <C-h> <C-w>h

      " <leader><space> to fzf Files
      nnoremap <silent> <leader><space> :Files<CR>
      " <leader>b to search buffers
      nnoremap <silent> <leader>b :Buffers<CR>

      " fast save <leader>w
      nmap <leader>w :w!<CR>

      " vim-commentary
      nnoremap <leader>/ :Commentary<CR>
      vnoremap <leader>/ :Commentary<CR>

      " resize with arrow keys
      nnoremap <silent> <C-Up>    :resize -2<CR>
      nnoremap <silent> <C-Down>  :resize +2<CR>
      nnoremap <silent> <C-Left>  :vertical resize -2<CR>
      nnoremap <silent> <C-Right> :vertical resize +2<CR>

      " toggle nerdtree
      map <C-n> :NERDTreeToggle<CR>

      " split windows
      noremap <leader>h :split<CR>
      noremap <leader>v :vsplit<CR>

      " Useful mappings for managing tabs
      map <leader>tn :tabnew<CR>
      map <leader>to :tabonly<CR>
      map <leader>tc :tabclose<CR>
      map <leader>tm :tabmove<CR>
      map <leader>t<leader> :tabnext<CR>

      " Close buffer
      noremap <leader>c :bd<CR>

      " remove highlighting
      nnoremap <leader>nh :noh<CR>

      " open terminal
      nnoremap <leader>t :term<CR>

      " toggle spell check
      nnoremap <leader>s :setlocal spell!<CR>

      " copy+paste too system clipboard
      nnoremap <leader>y "*y
      nnoremap <leader>p "*p

      " --------------- costum commands ------------------

      function! SetTab(n)
        let &l:tabstop=a:n
        let &l:softtabstop=a:n
        let &l:shiftwidth=a:n
        set expandtab
      endfunction

      " set tabwidth with :SetTab <width>
      command! -nargs=1 SetTab call SetTab(<f-args>)

      function! Trim()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
      endfunction

      command! -nargs=0 Trim call Trim()

      " --------------- coc settings ------------------

      " Use tab for trigger completion with characters ahead and navigate.
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config.
      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ CheckBackspace() ? "\<TAB>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion.
      if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
      else
        inoremap <silent><expr> <c-@> coc#refresh()
      endif

      " Make <CR> auto-select the first completion item and notify coc.nvim to
      " format on enter, <cr> could be remapped by other vim plugin
      inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      " Use `[g` and `]g` to navigate diagnostics
      " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " GoTo code navigation.
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window.
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction

      " Highlight the symbol and its references when holding the cursor.
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Symbol renaming.
      nmap <leader>rn <Plug>(coc-rename)

      " Formatting selected code.
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying codeAction to the selected region.
      " Example: `<leader>aap` for current paragraph
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Remap keys for applying codeAction to the current buffer.
      nmap <leader>ac  <Plug>(coc-codeaction)
      " Apply AutoFix to problem on the current line.
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Run the Code Lens action on the current line.
      nmap <leader>cl  <Plug>(coc-codelens-action)

      " Map function and class text objects
      " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
      xmap if <Plug>(coc-funcobj-i)
      omap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap af <Plug>(coc-funcobj-a)
      xmap ic <Plug>(coc-classobj-i)
      omap ic <Plug>(coc-classobj-i)
      xmap ac <Plug>(coc-classobj-a)
      omap ac <Plug>(coc-classobj-a)

      " Remap <C-f> and <C-b> for scroll float windows/popups.
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use CTRL-S for selections ranges.
      " Requires 'textDocument/selectionRange' support of language server.
      nmap <silent> <C-s> <Plug>(coc-range-select)
      xmap <silent> <C-s> <Plug>(coc-range-select)

      " Add `:Format` command to format current buffer.
      command! -nargs=0 Format :call CocActionAsync('format')

      " Add `:Fold` command to fold current buffer.
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " Add `:OR` command for organize imports of the current buffer.
      command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

      " Add (Neo)Vim's native statusline support.
      " NOTE: Please see `:h coc-status` for integrations with external plugins that
      " provide custom statusline: lightline.vim, vim-airline.
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function',\'\')}

      " Mappings for CoCList
      " Show all diagnostics.
      nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
      " Manage extensions.
      nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
      " Show commands.
      nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
      " Find symbol of current document.
      nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
      " Search workspace symbols.
      nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
      " Do default action for next item.
      nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
      " Do default action for previous item.
      nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
      " Resume latest coc list.
      nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

      " --------------- lightline settings ------------------

      let g:lightline = {
            \ 'colorscheme': 'palenight',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'cocstatus', 'readonly', 'filename', 'gitbranch', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'cocstatus': 'coc#status',
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ }

      " --------------- vimwiki ------------------

      let g:vimwiki_syntax = 'markdown'
      let g:vimwiki_ext = '.md'
      let g:vimwiki_automatic_nested_syntaxes = 1
      let g:vimwiki_links_space_char = '_'
      let g:vimwiki_list = [
            \ { 'name': '/', 'path': '~/vimwiki/' },
            \ { 'name': 'fleeting', 'path': '~/vimwiki/fleeting' },
            \ { 'name': 'permanent', 'path': '~/vimwiki/permanent' },
            \ ]

      " --------------- vim-zettel ------------------

      let g:zettel_random_chars=16
      let g:zettel_date_format = "%Y-%m-%d"
      let g:zettel_format = "%y%m%d-%H:%M-%title"
      let g:zettel_default_mappings = 0
      let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always "
      let g:zettel_options = [{"template": "~/vimwiki/template.tpl", "front_matter" : [["taxonomies", ""]]}]
      augroup filetype_vimwiki
        autocmd!
        autocmd FileType vimwiki nmap <leader>zn :ZettelNew
        autocmd FileType vimwiki nmap <leader>zN :ZettelNewSelectedMap
        autocmd FileType vimwiki nmap <leader>zs :ZettelSearchMap
        autocmd FileType vimwiki nmap <leader>zo :ZettelOpen<CR>
        autocmd FileType vimwiki nmap <leader>zb :ZettelBackLinks<CR>
        autocmd FileType vimwiki nmap <leader>zf :AddVimFootnote
        autocmd FileType vimwiki nmap <leader>zr :ReturnFromFootnote
      augroup END

      " --------------- autocmds ------------------

      autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
      " quit if NERDTree is the last buffer open
      autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | quit | endif
    '';
  };
}
