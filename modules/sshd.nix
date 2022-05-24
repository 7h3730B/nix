{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.ssh-server;
in {
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
      ];
      description = ''
        public keys for authentication
      '';
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
  };
}