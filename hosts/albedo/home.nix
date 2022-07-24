{ pkgs
, unstable
, nixos
, home
, username
, ...
}:
let
  wallpaper = ../../wallpaper/nix-wallpaper-dracula.png;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # age.secrets.sshConfig = {
  #   file = ../../secrets.ssh.config;
  #   owner = "${username}";
  # };

  age.secrets.publicCert = {
    file = ../../secrets/public.cert;
    path = "/home/${username}/tasks/keys/public.cert";
    owner = "${username}";
  };
  age.secrets.privateKey = {
    file = ../../secrets/private.key;
    path = "/home/${username}/tasks/keys/private.key";
    owner = "${username}";
  };
  age.secrets.caCert = {
    file = ../../secrets/ca.cert;
    path = "/home/${username}/tasks/keys/ca.cert";
    owner = "${username}";
  };

  home-manager.users."${username}" = {
    imports = [
      ../../profiles/home/full-graphical.nix
      ../../profiles/home/configs/ssh
      ../../profiles/home/configs/taskwarrior
    ];

    home.packages = with pkgs; [
      asciinema
      delta
      exa
      fd
      file
      jq
      ranger
      xclip
      gh
      playerctl
      rofi
      ranger
      dunst
      dmenu
      feh

      nodejs
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      BROWSER = "brave";
      TERMINAL = "alacritty";
      SHELL = "${pkgs.zsh}/bin/zsh";
      SXHKD_SHELL = "/bin/sh";
    };

    programs.git = {
      signing = {
        key = "095A8277322FACFB";
        signByDefault = true;
      };
    };

    services.polybar.config."module/eth".interface = "ens18";
    services.polybar.script = with pkgs; ''
      polybar main &
    '';
  };
}
