# https://tailscale.com/blog/nixos-minecraft/
{ pkgs, config, ... }: {
  services.tailscale.enable = true;
  environment.systemPackages = [ pkgs.tailscale ];

  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  # networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # age.secrets.tailscale-preauthkey.file = ../secrets/tailscale-preauthkey;
  # systemd.services.tailscale-autoauth = {
  #   description = "Uses preauth key to connect to tailscale";

  #   after = [ "network-pre.target" "tailscale.service" ];
  #   wants = [ "network-pre.target" "tailscale.service" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig.Type = "oneshot";

  #   script = with pkgs; ''
  #     # wait for tailscale to settle
  #     sleep 2

  #     # check if auth
  #     status="$(${tailscale}/bin/tailscale status -json > ${jq}/bin/jq -r .BackendState)"
  #     if [ $status = "Running"]; then # nothing
  #       exit 0
  #     fi

  #     ${tailscale}/bin/tailscale up --authkey $(cat ${config.age.secrets.tailscale-preauthkey.path})
  #   '';
  # };
}