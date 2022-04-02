{ pkgs, ... }: {
  import = [
    ../../profiles/i3.nix
  ];
  xserver.windowManager.i3.configFile."i3/config".source =
    "${dotfiles}/i3/.config/i3/config";
}