{ pkgs
, config 
, lib
, ... }: 
let
  wallpaper = ../../../../wallpaper/nix-wallpaper-dracula.png;
  palette = (import ../../../../palettes);
in
{
  xsession = {
    enable = true;
    numlock.enable = true;

    windowManager.bspwm = {
      enable = true;

      # monitors = {
      #   focused = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];
      # };

      # settings = {
      #     focus_follows_pointer = true;
      #     borderless_monocle = true;
      #     gapless_monocle = true;

      #     border_width = 2;
      #     window_gap = 28;
      #     top_padding = 8;
      #     bottom_padding = 0;

      #     normal_border_color = palette.primary.background;
      #     active_border_color = palette.primary.background;
      #     focused_border_color = palette.primary.foreground;
      # };

      extraConfig = ''
        bspc monitor -d 1 2 3 4 5 6 7 8 9 0
      '';

      startupPrograms = [
        "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper}"
      ];
    };
  };
}