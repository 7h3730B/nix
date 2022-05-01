{ pkgs
, colorscheme
, palette
, ... }: {

  monitors = {
    "focused" = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];
  };

  settings = {
      focus_follows_pointer = true;
      borderless_monocle = true;
      gapless_monocle = true;

      border_width = 2;
      window_gap = 28;
      top_padding = 8;
      bottom_padding = 0;

      normal_border_color = palette.primary.background;
      active_border_color = palette.primary.background;
      focused_border_color = palette.primary.foreground;
  };
}