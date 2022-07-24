{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.ark-server;

  script = pkgs.writeText "install-script" ''
    force_install_dir ${cfg.dataDir}
    login anonymous
    app_update 376030
    quit
  '';
in
{
  options.ark-server = {
    enable = mkEnableOption "ark dedicated server";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/ark-server";
      description = ''
        Directory to store all data
      '';
    };

    launchOptions = mkOption {
      type = types.str;
      default = "";
      description = ''
        Provide all launchOptions
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Wether to open ports in the firewall
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.ark-server = {
      description = "Ark server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "ark-server";
    };
    users.groups.ark-server = { };

    systemd.services.ark-server =
      let
        steamcmd = "${pkgs.steamcmd}/bin/steamcmd";
        steam-run = "${pkgs.steam-run}/bin/steam-run";
      in
      {
        description = "Ark Server Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${steam-run} ${cfg.dataDir}/ShooterGame/Binaries/Linux/ShooterGameServer ${cfg.launchOptions}";
          Restart = "always";
          WorkingDirectory = cfg.dataDir;
          StateDirectory = "ark-server";
          User = "ark-server";
          Group = "ark-server";
          # Pre start can take a while else results in a infinity loop
          TimeoutSec = "15min";
          # Security settings
          # not able to use, 'cause of agenix needing a valid user
          # DynamicUser = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamily = [ "AF_UNIX AF_INET AF_INET16" ];
          LockPersonality = true;
          RestrictRealTime = true;
          # SystemCallFilter =
          #   "~"
          #   + (concatStringsSep " " [
          #     "@clock"
          #     "@cpu-emulation"
          #     # "@debug"
          #     "@keyring"
          #     # "@memlock"
          #     "@obsolete"
          #     "@raw-io"
          #     "@reboot"
          #     "@resources"
          #     "@setuid"
          #     "@swap"
          #   ]);
          ProtectHome = "tmpfs";
          # Should already be set by DynamicUsers
          RemoveIPC = true;
          PrivateTmp = true;
          PrivateDevices = true;
          NoNewPrivileges = true;
          RestrictSUIDSGID = true;
          ProtectSystem = "strict";
        };
        preStart = ''
          ${steamcmd} +runscript ${script}
        '';
      };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ 7777 7778 27015 ];
    };
  };
}
