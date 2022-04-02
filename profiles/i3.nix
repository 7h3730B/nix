{ pkgs, dotfiles, ... }: {
  services = {
    xserver = {
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
            i3ock
          ];
        };
      };
    };
  };
}
