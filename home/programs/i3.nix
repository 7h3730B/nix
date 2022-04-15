{ pkgs, dotfiles, ... }: {
  xsession = {
    enable = true;
    desktopManager.xterm.enable = true;
    displayManager.defaultSession = "none+i3";
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
