{
  description = "7h3730B's NixOS Flake";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    dotfiles.url = "github:7h3730B/.dotfiles/master";
    dotfiles.flake = false;
  };

  outputs = { self, nixpkgs, ... }@inputs:  {
    nixosConfiguration."nixos-pen-vm" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
