{ pkgs
, palette
, ... }:
let
  extenions = import ./extension.nix { inherit pkgs; };
in {
  inherit extensions;
  
  package = pkgs.vscodium;
}