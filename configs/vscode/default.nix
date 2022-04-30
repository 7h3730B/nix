{ pkgs
, palette
, ... }: {
  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
    dracula-theme.theme-dracula
    vscodevim.vim
  ];

  package = pkgs.vscodium;
}