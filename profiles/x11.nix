{ ... }: {
  services.xserver = {
    enable = true;
    layout = "eu";
    libinput.enable = true;

    displayManager.xterm.enable = true;
    windowManager.bspwm.enable = true;
    displayManager.defaultSession = "none+bspwm";
  };

  services.xbanish.enable = true;
}