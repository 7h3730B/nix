{ pkgs
, config
, lib
, ... }: {
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      dracula-theme.theme-dracula
      vscodevim.vim
    ];

    package = pkgs.vscodium;
  };
}