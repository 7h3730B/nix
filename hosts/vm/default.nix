# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, pkgs, unstable, nixos, home, lib, system, ... }:
with builtins;
let
  name = "7h3730b";
  username = "teo";
  hostname = "nixos-pen-vm";
in
{
  system.stateVersion = "21.11";
  networking.hostName = "${hostname}";

  imports =
    [
      ./hardware-configuration.nix
      ../base.nix

      ../../profiles/xrdp.nix
      (../../home + "/${username}")
    ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };
    };
    initrd.luks.devices = {
      crypt = {
        device = "/dev/sda2";
        preLVM = true;
      };
    };
  };

  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    resolved = {
      enable = true;
      extraConfig = ''
        DNS=1.1.1.1
      '';
    };
  };

  security.protectKernelImage = true;

  nix.trustedUsers = [ "root" username ];

  users.users.${username} = {
    description = name;
    isNormalUser = true;
    group = "users";
    extraGroups = [ "audio" "disk" "docker" "networkmanager" "video" "wheel" ];
    createHome = true;
    uid = 1000;
    home = "/home/${username}";
  };
}
