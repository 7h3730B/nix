let 
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
  ];

  systems = {
    albedo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjNvjIYtI/DiFAZLNYXHrlhwe44dlzIREkQzZQoL3bk root@albedo";
    aqua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdzAWQr36WL+9Nj+5MfRr2hDdyjOlVKuVX0394XTKvd root@aqua";
    emilia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHT5zgG+mF/SXnVL7lC8DRR0N0aWKL+2sQxzGTHGf1I+ root@emilia";
  };

  keysForSystems = list: users ++ (builtins.map (s: systems."${s}") list);
in 
{
  "tailscale-preauthkey".publicKeys = keysForSystems [ "albedo" "aqua" "emilia" ];
}
