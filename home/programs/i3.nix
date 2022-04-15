{ pkgs, dotfiles, ... }: {
  home.packages = with pkgs; [ dmenu ];

  xsession = {
    enable = true;
    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };

  programs = {
    rofi = {
      enable = true;
    };
    dmneu = {
      enable = true;
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
    polybar = {
      enable = true;
    };
  };
}
