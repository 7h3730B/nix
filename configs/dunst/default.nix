{ pkgs
, palette
, ... }: {
  iconTheme = {
    name = "Papirus";
    package = pkgs.papirus-icon-theme;
    size = "48x48";
  };

  setting = {
    global = {
      seperator_height = "1";
      seperator_color = palette.bright.black;

      icon_position = "left";
      padding = "16";
      horizontal_padding = "16";
      font = "Noto Sans Nerd Font 10";

      markup = "full";
      format = "<b>%a = %s</b>\\n%b";

      alignment = "left";
      vertical_alignment = "center";
    };

    shortcuts = {
      close = "ctrl+space";
      close_all = "ctrl+shift+space";
      history = "ctrl+grave";
      context = "ctrl+period";
    };

    urgency_low = {
      background = palette.normal.black;
      foreground = palette.normal.white;
      timeout = 10;
    };

    urgency_normal = {
      background = palette.normal.black;
      foreground = palette.normal.white;
      timeout = 10;
    };

    urgency_critical = {
      background = palette.normal.black;
      foreground = palette.normal.white;
      timeout = 0;
    };
  };
}