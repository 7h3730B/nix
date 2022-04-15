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
      script = ''
        # Terminate already running bar instances.
        killall -q polybar

        # Wait until the processes have been shut down.
        while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

        # Launch Polybar, using default config location ~/.config/polybar/config
        # polybar topbar -r &
        # polybar bottombar -r

        # Launch an instance of polybar for every monitor connected
        if type "xrandr"; then
          for m in $(xrandr -q | grep " connected" | cut -d" " -f1); do
          MONITOR=$m polybar -r topbar &
          done
        else
          polybar -r topbar &
        fi
      '';
    };
  };
}
