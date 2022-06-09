{ config, ... }: {
  age.secrets.zncConf = {
    file = ../../secrets/znc.conf;
    owner = "znc";
  };
  services.znc = {
    enable = true;
    mutable = false;
    configFile = config.age.secrets.zncConf.path;
  };
  networking.firewall.allowedTCPPorts = [ 1025 ];
}