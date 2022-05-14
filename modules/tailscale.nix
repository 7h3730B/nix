{ pkgs, config, ... }: {
  services.tailscale.enable = true;
  environment.systemPackages = [ pkgs.tailscale ];

  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  # networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
}