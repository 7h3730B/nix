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

  # age.secrets.sshConfig = {
  #   file = ../../secrets.ssh.config;
  #   owner = "${username}";
  # };

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
      SXHKD_SHELL = "${pkgs.bash}/bin/bash";
    };

    programs.git = {
      signing = {
        key = "095A8277322FACFB";
        signByDefault = true;
      };
    };

    services.polybar.config."module/eth".interface = "ens18";
    services.polybar.script = with pkgs; ''
      polybar main &
    '';
  };
}
