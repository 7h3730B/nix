{ pkgs
, ...
}: {
  services.xserver = {
    enable = true;
    layout = "eu";
    libinput.enable = true;

    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+bspwm";
    windowManager.bspwm.enable = true;
  };

  services.xbanish.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.xev
    xorg.xkill
    xorg.xrandr
  ];
}
