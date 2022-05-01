{ pkgs
, palette
, ... }: {
  plugins = with pkgs.vimPlugins; [
    airline
    solarized
    vim-airline-themes
    vim-nix
  ];

  extraConfig = ''
    set rnu

    syntax on

    set nowrap
    set encoding=utf-8
    set fileencoding=utf-8
    set ruler
    set splitbelow
    set splitright
    set number
    set background=dark
    set smartindent
    set tabstop=4
    set shiftwidth=4
    set expandtab
    syntax enable
    set t_Co=256
    set spell spelllang=en_us
    hi clear SpellBad
    hi SpellBad cterm=underline
    hi SpellBad ctermbg=NONE
    match ErrorMsg '\s\+$'
    
    let g:airline_powerline_fonts=1
    let g:airline_theme='solarized'

    set laststatus=2
  '';
}