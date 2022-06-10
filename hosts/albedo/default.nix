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
  
  base = {
    enable = true;
    DNSOverTLS = true;
    zramSwap = true;
    networkTweaks = true;
  };
  
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
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    hostName = "kazuma";
  }];
  nix.distributedBuilds = true;

  # move to encrypted secrets and create build user on kazuma host
  programs.ssh.extraConfig = ''
    Host kazuma
      HostName kazuma.teo.beer
      Port 4444
      User root
      IdentitiesOnly yes
      IdentityFile /home/teo/.ssh/id_ed25519
  '';

  nix.extraOptions = ''
    builders-use-substitutes = true
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