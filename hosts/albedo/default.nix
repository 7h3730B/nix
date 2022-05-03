{ pkgs
, unstable
, nixos
, home
, username
, ... }:
let
  hostname = "albedo";
  palette = (import ../../palettes);
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
      ../base.nix

      # ../../modules/tailscale.nix
      ../../modules/xrdp.nix
      ../../modules/fonts.nix

      ../../profiles/x11.nix
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
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.interfaces.ens18.useDHCP = true;

  services.xserver = {
    enable = true;

    displayManager.lightdm.greeters.mini = {
      enable = true;
      user = username;
      extraConfig = ''
        text-color = "${palette.primary.foreground}"
        password-background-color = "${palette.normal.cyan}"
        window-color = "${palette.primary.background}"
        border-color = "${palette.bright.white}"
      '';
    };
  };

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