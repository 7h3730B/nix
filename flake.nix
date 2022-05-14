{
  description = "7h3730B's NixOS Flake";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";

    home.url = "github:nix-community/home-manager";
  };

  outputs = { self, unstable, nixos, home, agenix, ... }@inputs: 
    let
      inherit (nixos) lib;

      username = "teo";
      overlay = import ./pkgs;

      extraModules = [
        home.nixosModules.home-manager
        agenix.nixosModule
      ];

      importPkgs = pkgs: overlays: system: import pkgs {
        inherit system overlays;
        overlay = [ overlay ] ++ overlays;
        config = {
          allowUnfree = true;
        };
      };

      nixosSystem =
      { system ? "x86_64-linux"
      , configuration ? {}
      , modules ? []
      , overlays ? []
      , extraModules ? []
      , specialArgs ? {}
      , ...
      }:
      let
        pkgs = (importPkgs nixos overlays system);
      in
        lib.nixosSystem {
          inherit system;
          modules = [ configuration { nixpkgs = { inherit pkgs; }; } ] ++ modules ++ extraModules;
          specialArgs = {
            inherit 
              (inputs)
              unstable
              nixos
              home;
            inherit
              username;
          } // specialArgs;
      };
    in 
    {
      nixosConfigurations."albedo" = nixosSystem {
          configuration = ./hosts/albedo;
          extraModules = extraModules;
        };
    };
}
