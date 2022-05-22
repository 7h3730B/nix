{
  description = "7h3730B's NixOS Flake";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";

    home.url = "github:nix-community/home-manager";

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, unstable, nixos, home, agenix, deploy-rs, ... }@inputs: 
    let
      inherit (nixos) lib;

      username = "teo";
      overlay = import ./pkgs;

      extraModules = [
        home.nixosModules.home-manager
        agenix.nixosModules.age
        ./modules/deploy.nix
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
        pkgs = (importPkgs unstable overlays system);
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
        overlays = sharedOverlays;
      };

      nixosConfigurations."aqua" = nixosSystem {
        configuration = ./hosts/aqua;
        extraModules = extraModules;
        overlays = sharedOverlays;
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      deploy = {
        magicRollback = true;
        autoRollback = true;

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
              sshOpts = [ "-p" nixosConfig.config.deploy.port];
              path = deploy-rs.lib.${nixosConfig.system}.activate.nixos nixosConfig;
            };
          })
          (nixos.lib.filterAttrs
            (_: v: v.config.deploy.enable)
            self.nixosConfigurations);
      };
    };
}
