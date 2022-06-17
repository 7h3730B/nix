{ pkgs
, unstable
, nixos
, home
, username
, ...
}:
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
      ../../profiles/home/full-graphical.nix
      ../../profiles/home/configs/ssh
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
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      BROWSER = "brave";
      TERMINAL = "alacritty";
      SHELL = "${pkgs.zsh}/bin/zsh";
      SXHKD_SHELL = "/bin/sh";
    };

    programs.git = {
      signing = {
        key = "0x4D08FF5FFA1A8A96";
        signByDefault = true;
      };
    };

    services.polybar.config."module/eth".interface = "eth0";
    services.polybar.script = with pkgs; ''
      polybar main &
    '';
  };
}

