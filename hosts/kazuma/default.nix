{ pkgs
, unstable
, nixos
, home
, username
, lib
, config
, ...
}:
let
  hostname = "kazuma";
  sshPort = 4444;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
      ./ark-server.nix
    ];

  base = {
    enable = true;
    DNSOverTLS = true;
    zramSwap = true;
    networkTweaks = true;
  };

  deploy = {
    enable = true;
    ip = "${hostname}.teo.beer";
    port = sshPort;
  };

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
  };

  age.secrets.arkSettings = {
    file = ../../secrets/ark-settings.ini;
    path = "${config.ark-server.dataDir}/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini";
    owner = "ark-server";
  };
  ark-server = {
    enable = true;
    openFirewall = true;
    launchOptions = ''
      TheIsland?listen?noTributeDownloads=true?PreventDownloadSurvivors=true?PreventDownloadItems=true?PreventDownloadDinos=true?AutoSavePeriodMinutes=5?alwaysNotifyPlayerJoined=true?alwaysNotifyPlayerLeft=true?SessionName=Pumper?RCONEnabled=False?MaxPlayers=5 -NoBattlEye -server -crossplay -log
    '';
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  networking.interfaces.ens18.useDHCP = true;

  security.protectKernelImage = true;

  nix.trustedUsers = [ "root" ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    initialPassword = "${hostname}123";
  };

  documentation.enable = false;
  # Needs to be false, so gtk can build and steam-run can build
  environment.noXlibs = false;
}
