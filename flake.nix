{
  description = "7h3730B's NixOS Flake";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home.url = "github:nix-community/home-manager";
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, unstable, nixos, home, agenix, deploy-rs, flake-utils, ... }@inputs: 
    let
      inherit (nixos) lib;

      username = "teo";
      overlay = import ./pkgs;

      extraModules = [
        home.nixosModules.home-manager
        agenix.nixosModules.age
        ./modules/base.nix
        ./modules/deploy.nix
        ./modules/sshd.nix
        ./modules/tailscale.nix
        ./modules/xrdp.nix
      ];

      sharedOverlays = [
        agenix.overlay
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
          modules = [
            configuration {
              nixpkgs = { inherit pkgs; };
              deploy = { inherit system; };
            }
          ] ++ modules ++ extraModules;
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
        overlays = sharedOverlays;
      };

      nixosConfigurations."aqua" = nixosSystem {
        configuration = ./hosts/aqua;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      nixosConfigurations."tanya" = nixosSystem {
        configuration = ./hosts/tanya;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      nixosConfigurations."kazuma" = nixosSystem {
        configuration = ./hosts/kazuma;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      nixosConfigurations."emilia" = nixosSystem {
        system = "aarch64-linux";
        configuration = ./hosts/emilia;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      nixosConfigurations."rem" = nixosSystem {
        system = "aarch64-linux";
        configuration = ./hosts/rem;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      nixosConfigurations."ram" = nixosSystem {
        system = "aarch64-linux";
        configuration = ./hosts/ram;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      deploy = {
        magicRollback = false;
        autoRollback = false;

        # build all systems with nix run ".#deploy-rs" -- -s
        # build just onw system with ".#name"
        nodes = builtins.mapAttrs
          (_: nixosConfig: {
            hostname =
              if builtins.isNull nixosConfig.config.deploy.ip
              # should be the same as in tailscale DNS
              then "${nixosConfig.config.networking.hostName}"
              else "${nixosConfig.config.deploy.ip}";

            profiles.system = {
              user = "root";
              sshUser = "root";
              sshOpts = [ "-p" (builtins.toString nixosConfig.config.deploy.port) ];
              path = deploy-rs.lib.${nixosConfig.config.deploy.system}.activate.nixos nixosConfig;
            };
          })
          (nixos.lib.filterAttrs
            (_: v: v.config.deploy.enable)
            self.nixosConfigurations);

      };
    } // flake-utils.lib.eachDefaultSystem (system: 
      # because of nix > 2.8 issue
      # https://github.com/serokell/deploy-rs/issues/155
      let pkgs = nixos.legacyPackages.${system};
      in {
        apps.deploy-rs = deploy-rs.defaultApp."${system}";

        devShells.default = pkgs.mkShell {
          buildInputs = [ deploy-rs.defaultPackage."${system}" ];
        };
      });
}
