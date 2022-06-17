{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.ssh-server;
in
{
  options.ssh-server = {
    enable = mkEnableOption "openssh server";

    ports = mkOption {
      type = types.listOf types.port;
      default = [ 22 ];
      description = ''
        ports sshd should listen
      '';
    };

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = ''
        if password Auth should be allowed
      '';
    };

    rootKeys = mkOption {
      type = types.listOf types.str;
      # TODO: get these keys from one place, maybe github?
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIClgut/WhKMP94YUlSY1fGe0UaKfrAMv/mQBoBbLTsB1 teo@megumin"
      ];
      description = ''
        public keys for authentication
      '';
    };

    fail2ban = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      ignoreIP = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      inherit (cfg) enable ports passwordAuthentication;
      # kbdInteractiveAuthentication = false;
      allowSFTP = false;
      forwardX11 = false;
      permitRootLogin = "prohibit-password";
      openFirewall = true;
    };
    users.users.root.openssh.authorizedKeys.keys = cfg.rootKeys;
    services.fail2ban = {
      inherit (cfg.fail2ban) enable ignoreIP;
    };
  };
}
