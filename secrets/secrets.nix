let 
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG+H/iAAM1BPI4Ys/c80paJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
  ];

  systems = {
    albedo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjNvjIYtI/DiFAZLNYXHrlhwe44dlzIREkQzZQoL3bk root@albedo";
  };

  keysForSystems = list: users ++ (builtins.map (s: systems."${s}") list);
in {
  "supersecretpw.txt".publicKeys = keysForSystems [ "albedo" ];
}