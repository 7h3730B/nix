{ config, ... }: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Include ${config.age.secrets.sshConfig.path}
    '';
  };
}