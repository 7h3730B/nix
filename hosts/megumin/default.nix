{ pkgs
, unstable
, nixos
, home
, username
, config
, ... }:
let
  hostname = "megumin";
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
      ./home.nix
    ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;
  };

  users.users.nixos = {
    shell = "${pkgs.zsh}/bin/zsh";
  };

  documentation.enable = false;
  environment.noXlibs = true;
}