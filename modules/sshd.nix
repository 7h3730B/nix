{ ... }: {
  services.openssh = {
    enable = true;
    # kbdInteractiveAuthentication = false;
    passwordAuthentication = false;
    allowSFTP = false;
    forwardX11 = false;
    permitRootLogin = "prohibit-password";
    openFirewall = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo" ];
}