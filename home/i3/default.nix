{ pkgs, dotfiles, ... }: {
  imports = [
    ../../profiles/i3.nix
  ];
  services.xserver.windowManager.i3.configFile =
    "${dotfiles}/i3/.config/i3/config";
}
