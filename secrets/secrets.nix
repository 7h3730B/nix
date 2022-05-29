let 
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
  ];

  systems = {
    albedo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjNvjIYtI/DiFAZLNYXHrlhwe44dlzIREkQzZQoL3bk root@albedo";
    aqua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdzAWQr36WL+9Nj+5MfRr2hDdyjOlVKuVX0394XTKvd root@aqua";
    emilia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILR8+VDHcLM2XibLDb9DxatXi4LiPyEscsv3KsNw88yo root@emilia";
    ram = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhcgrnV9ykRgcByzRC/JP1MowtAsAkeELX7UhMjULak root@ram";
  };

  keysForSystems = list: users ++ (builtins.map (s: systems."${s}") list);
in 
{
  "tailscale-preauthkey".publicKeys = keysForSystems [ "albedo" "aqua" "emilia" "ram" ];

  "ssh.config".publicKeys = keysForSystems [ "albedo" ];

  "znc.conf".publicKeys = keysForSystems [ "albedo" "emilia" ];
}
