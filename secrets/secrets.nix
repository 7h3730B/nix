let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
  ];

  systems = {
    albedo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjNvjIYtI/DiFAZLNYXHrlhwe44dlzIREkQzZQoL3bk root@albedo";
    aqua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdzAWQr36WL+9Nj+5MfRr2hDdyjOlVKuVX0394XTKvd root@aqua";
    emilia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILR8+VDHcLM2XibLDb9DxatXi4LiPyEscsv3KsNw88yo root@emilia";
    kazuma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAW6Yvi+upXoa1qtBN0GC7kxUJ/D2tRQOy8Jis/rw5Cg root@kazuma";
    ram = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPslo+FB456KPhmezoHtCMImA+ku5G985C7orGdd/PWZ root@ram";
    rem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeLvHFgGd9kwQEx6rJXSN3MmNt8uzfwlII6X4qqHk3x root@rem";
  };

  keysForSystems = list: users ++ (builtins.map (s: systems."${s}") list);
in
{
  "tailscale-preauthkey".publicKeys = keysForSystems [ "albedo" "aqua" "emilia" "ram" "rem" ];

  "ssh.config".publicKeys = keysForSystems [ "albedo" ];

  "znc.conf".publicKeys = keysForSystems [ "albedo" "ram" ];

  "wpa_supplicant.conf".publicKeys = keysForSystems [ "albedo" ];

  "spotifypw.txt".publicKeys = keysForSystems [ "albedo" "ram" ];

  "ark-settings.ini".publicKeys = keysForSystems [ "albedo" "kazuma" ];
}
