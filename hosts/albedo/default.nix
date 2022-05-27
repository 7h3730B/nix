{ pkgs
, unstable
, nixos
, home
, username
, lib
, ... }:
let
  hostname = "albedo";
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
  
  ssh-server = {
    enable = true;
    passwordAuthentication = true;
    rootKeys = [];
  };

  tailscale = {
    enable = true;
    service = true;
  };

  xrdp = {
    enable = true;
  };

  nix.maxJobs = lib.mkDefault 2;

  nix.buildMachines = [{
    systems = [ "x86_64-linux" "aarch64-linux" ];
    maxJobs = 4;
    speedFactor = 2;
    suportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
    # TODO: remove this in favor of sshconfig
    hostName = "kazuma.teo.beer";
    sshUser = "root";
    sshKey = "/home/teo/id_ed25519";
  }];
  nix.distributedBuilds = true;

  nix.extraOptions = ''
    builders-use-substitues = true
  '';

  # compile for arm
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
  };

  zramSwap.enable = true;

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.interfaces.ens18.useDHCP = true;

  sound.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    helvum
    tldr
  ];

  services = {
    resolved = {
      enable = true;
      dnssec = "true";
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
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
    initialPassword = "123";
  };
}