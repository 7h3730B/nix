{ pkgs
, unstable
, nixos
, home
, username
, ... }: 
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
    };

    programs.git = {
      signing = {
        key = "095A8277322FACFB";
        signByDefault = true;
      };
    };

    services.polybar.script = with pkgs; ''
      monitors=$(xrandr | grep ' connected ' | cut -d' ' -f1)

      for monitor in $monitors; do
        MONITOR="$monitor" polybar main &
      done
    '';

    xsession.startupPrograms = [ "systemctl --user restart polybar" ];
  };
}