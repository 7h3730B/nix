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
      inherit (nixos) lib;

      extraModules = [
        home.nixosModules.home-manager
      ];
    in 
    {
      overlay = import ./pkgs;

      importPkgs = pkgs: overlays: system:
        import pkgs {
          inherit system overlays;
          overlay = [ self.overlay ] ++ overlays;
          config = {
            allowUnfree = true;
          };
        };

      nixosSystem =
      { system ? "x86_64-linux"
      , configuration ? {}
      , modules ? []
      , overlays ? [ self.overlay ]
      , extraModules ? []
      , specialArgs ? {}
      , ...
      }:
      let
        pkgs = self.importPkgs nixos overlays system;
      in
        lib.nixosSystem {
          inherit system specialArgs;
          
          modules = [ configuration { nixpkgs = { inherit pkgs; }; } ] ++ modules ++ extraModules;
      };
      
      nixosHosts = {
        "nixos-pen-vm" = {
          configuration = ./hosts/vm;
          specialArgs = { inherit (inputs) unstable nixos home dotfiles; };
          extraModules = extraModules;
        };
      };

      nixosConfigurations = {
        "nixos-pen-vm" = self.nixosSystem self.nixosHosts."nixos-pen-vm";
      };
    };
}
