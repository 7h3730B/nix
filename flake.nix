{
  description = "7h3730B's NixOS Flake";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    home.url = "github:nix-community/home-manager";

    dotfiles.url = "github:7h3730B/.dotfiles/master";
    dotfiles.flake = false;
  };

  outputs = { self, unstable, nixos, home, dotfiles, ... }@inputs: 
    with builtins;
    let
    in 
    {
      nixosSystem =
      { system ? "x86_64-linux"
      , configuration ? {}
      , modules ? []
      , specialArgs ? {}
      , ...
      }:
        lib.nixosSystem {
          inherit system specialArgs;

          modules = [ configuration ] ++ modules;
      };
      
      nixosHosts = {
        "nixos-pen-vm" = {
          configuration = ./hosts/vm;
          specialArgs = { inherit (inputs) unstable nixos home dotfiles; };
        };
      };

      overlay = import ./pkgs;

      nixosConfigurations = {
        "nix-pen-vm" = self.nixosSystem self.nixosHosts."nixos-pen-vm";
      };
    };
}
