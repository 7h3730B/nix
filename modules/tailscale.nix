{ config, ... }: {
  services.tailscale.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  # networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  # networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
}