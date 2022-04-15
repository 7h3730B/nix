{ pkgs, dotfiles, ... }: {
  xsession = {
    enable = true;
    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          rofi
          polybar
          dunst
          picom
        ];
      };
    };
  };
  services = {
    picom = {
      enable = true;
    };
    dunst = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
        size = "48x48";
      };
    };
  };
}
