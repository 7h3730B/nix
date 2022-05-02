{ pkgs
, config
, lib
, ... }: {
  imports = [
    ./configs/alacritty
    ./configs/bspwm
    ./configs/dunst
    ./configs/git
    ./configs/picom
    ./configs/starship
    ./configs/sxhkd
    ./configs/tmux
    ./configs/vim
    ./configs/vscode
    ./configs/zsh
  ];
}