{ pkgs
, unstable
, nixos
, home
, username
, config
, ...
}:
let
  hostname = "megumin";
  sshPort = 4444;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
      ../../modules/fonts.nix
      ../../profiles/x11.nix
      ./home.nix
    ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "teo";
    startMenuLaunchers = true;
  };

  base = {
    enable = true;
    DNSOverTLS = false;
    zramSwap = false;
    networkTweaks = false;
  };

  tailscale = {
    enable = true;
    service = true;
  };

  # compile for arm
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
    fail2ban.enable = false;
  };

  xrdp = {
    enable = true;
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
    ];
  };

  documentation.enable = false;
  environment.noXlibs = true;
}
