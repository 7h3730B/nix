{ configDir
, pkgs
, wallpaper
, ... }: {
  # Terminal /cli
  programs.alacritty = {
    enable = true;
  } // (import "${configDir}/alacritty" {
    inherit pkgs palette;
  });

  programs.zsh = {
    enable = true;
  } // (import "${configDir}/zsh" {
    inherit pkgs;
  });

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
  } // (import "${configDir}/tmux" {
    inherit pkgs;
  });

  programs.git = {
    enable = true;
  } // (import "${configDir}/git");

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };

  # Desktop
  services.sxhkd = {
    enable = true;
  } // (import "${configDir}/sxhkd" {
    inherit configDir;
  });

  services.picom = {
    enable = true;
  } // (import "${configDir}/picom");

  services.dunst = {
    enable = true;
  } // (import "${configDir}/dunst" {
    inherit pkgs palette;
  });

  # Editors
  programs.vscode = {
    enable = true;
  } // (import "${configDir}/vscode" {
    inherit pkgs palette;
  });

  # TODO: move to neovim
  programs.vim = {
    enable = true;
  } // (import "${configDir}/vim" {
    inherit pkgs palette;
  });

  xsession = {
    enable = true;
    numlock.enable = true;

    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper}"
      ];
    } // (import "${configDir}/bspwm" {
      inherit pkgs colorscheme palette;
    });
  };
}