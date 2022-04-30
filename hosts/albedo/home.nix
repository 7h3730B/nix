{ pkgs
, unstable
, nixos
, home
, username
, colorscheme
, palette
, configDir
, ... }: 
let
  wallpaper = ../../wallpaper/nix-wallpaper-dracula.png;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users."${username}" = {
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
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      BROWSER = "brave";
      TERMINAL = "alacritty";
    };

    # Terminal /cli
    programs.alacritty = {
      enable = true;
    } // (import "${configDir}/alacritty") {
      inherit pkgs palette;
    };

    programs.zsh = {
      enable = true;
    } // (import "${configDir}/zsh") {
      inherit pkgs;
    };

    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    } // (import "${configDir}/starship");

    programs.tmux = {
      enable = true;
    } // (import "${configDir}/tmux") {
      inherit pkgs;
    };

    programs.git = {
      enable = true;
    } // (import "${configDir}/git");

    programs.fzf = {
      enable = true;
      enableZshIntegratin = true;
    };

    programs.bat = {
      enable = true;
    };

    # Desktop
    programs.sxhkd = {
      enable = true;
    } // (import "${configDir}/sxhkd") {
      inherit configDir;
    };

    programs.picom = {
      enable = true;
    } // (import "${configDir}/picom");

    programs.dunst = {
      enable = true;
    } // (import "${configDir}/dunst") {
      inherit pkgs palette;
    };

    # Editors
    programs.vscode = {
      enable = true;
    } // (import "${configDir}/vscode}") {
      inherit pkgs palette;
    };

    # TODO: move to neovim
    programs.vim = {
      enable = true;
    } // (import "${configDir}/vim") {
      inherit pkgs palette;
    };
  };

  xsession = {
    enable = true;

    windowManager.bspwm = {
      enable = true;
    } // (import "${configDir}/bspwm") {
      inherit pkgs colorscheme palette;
    };

    startupPrograms = [
      "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper}"
    ];
  };
}