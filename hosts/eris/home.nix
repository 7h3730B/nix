{ pkgs
, unstable
, lib
, nixos
, home
, username
, ...
}:
with lib;
let
  wallpaper = ../../wallpaper/nix-wallpaper-dracula.png;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users."${username}" = {
    imports = [
      ../../profiles/home/configs/git
      ../../profiles/home/configs/starship
      ../../profiles/home/configs/tmux
      ../../profiles/home/configs/zsh
      ../../profiles/home/configs/vim
    ];

    home.packages = with pkgs; [
      asciinema
      delta
      exa
      fd
      file
      jq
      ranger
      xclip
      gh
      playerctl
      rofi
      ranger
      dunst
      dmenu
      feh

      nodejs
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      SHELL = "${pkgs.zsh}/bin/zsh";
    };

    programs.git = {
      userName =  "";
      userEmail = "";
    };
  };
}

