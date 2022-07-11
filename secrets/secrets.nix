let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIClgut/WhKMP94YUlSY1fGe0UaKfrAMv/mQBoBbLTsB1 teo@megumin"
  ];

  systems = {
    albedo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjNvjIYtI/DiFAZLNYXHrlhwe44dlzIREkQzZQoL3bk root@albedo";
    aqua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdzAWQr36WL+9Nj+5MfRr2hDdyjOlVKuVX0394XTKvd root@aqua";
    emilia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILR8+VDHcLM2XibLDb9DxatXi4LiPyEscsv3KsNw88yo root@emilia";
    kazuma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAW6Yvi+upXoa1qtBN0GC7kxUJ/D2tRQOy8Jis/rw5Cg root@kazuma";
    ram = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPslo+FB456KPhmezoHtCMImA+ku5G985C7orGdd/PWZ root@ram";
    rem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeLvHFgGd9kwQEx6rJXSN3MmNt8uzfwlII6X4qqHk3x root@rem";
    megumin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpRRRbEnio3RjxjwbYD6frKNE0KZEGeC5SS3WtT/IVi root@7H3730B";
  };

  keysForSystems = list: users ++ (builtins.map (s: systems."${s}") list);
in
{
  "tailscale-preauthkey".publicKeys = keysForSystems [ "albedo" "aqua" "emilia" "ram" "rem" "megumin" ];

  "ssh.config".publicKeys = keysForSystems [ "albedo" ];

  "znc.conf".publicKeys = keysForSystems [ "albedo" "ram" ];

  "wpa_supplicant.conf".publicKeys = keysForSystems [ "albedo" ];

  "spotifypw.txt".publicKeys = keysForSystems [ "albedo" "ram" ];

  "ark-settings.ini".publicKeys = keysForSystems [ "albedo" "kazuma" ];

  "config.yml".publicKeys = keysForSystems [ "albedo" "megumin" "kazuma" ];

  "servers.yml".publicKeys = keysForSystems [ "albedo" "megumin" "kazuma" ];

  "ACSM.License".publicKeys = keysForSystems [ "albedo" "megumin" "kazuma" ];

  "docker_token".publicKeys = keysForSystems [ "albedo" "megumin" "kazuma" ];

  "grafanapw.txt".publicKeys = keysForSystems [ "albedo" "rem" ];

  "hostapd.conf".publicKeys = keysForSystems [ "albedo" "megumin" "ram" ];

  "paperless.txt".publicKeys = keysForSystems [ "albedo" "megumin" "ram" ];
}
