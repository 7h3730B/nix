{ pkgs
, unstable
, nixos
, home
, username
, config
, ...
}:
let
  hostname = "eris";
  sshPort = 4444;
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
    defaultUser = "${username}";
    startMenuLaunchers = true;
  };

  base = {
    enable = true;
    DNSOverTLS = false;
    zramSwap = false;
    networkTweaks = false;
  };

  security.protectKernelImage = true;

  nix.trustedUsers = [ "root" username ];

  users.defaultUserShell = pkgs.zsh;
  users.users."${username}" = {
    description = "${username}";
    isNormalUser = true;
    group = "users";
    extraGroups = [ "audio" "disk" "docker" "networkmanager" "video" "wheel" ];
    createHome = true;
    shell = pkgs.zsh;
    uid = 1000;
    home = "/home/${username}";
    initialPassword = "${hostname}123";
  };

  documentation.enable = false;
  environment.noXlibs = true;
}
