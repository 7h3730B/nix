{ pkgs
, ... }: {
  services.xserver = {
    enable = true;
    layout = "eu";
    libinput.enable = true;

    windowManager.bspwm.enable = true;
    displayManager.defaultSession = "none+bspwm";
    displayManager.lightdm.enable = true;
  };

  services.xbanish.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.xev
    xorg.xkill
    xorg.xrandr
  ];
}