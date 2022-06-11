let
  colorscheme = "tokyonight";
  palette = import ./tokyonight.nix;
in
{
  inherit (palette) primary normal bright;
}
