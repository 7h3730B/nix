{
  description = "7h3730B's NixOS Flake";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/master";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";
    home.inputs.utils.follows = "flake-utils";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixos";
    deploy-rs.inputs.utils.follows = "flake-utils";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixos";

    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixos";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixos";
    emacs-overlay.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, unstable, nixos, home, agenix, deploy-rs, flake-utils, nixos-wsl, emacs-overlay, ... }@inputs:
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
        ./modules/reverse-proxy.nix
      ];

      sharedOverlays = [
        agenix.overlay
      ];

      importPkgs = pkgs: overlays: system: import pkgs {
        inherit system overlays;
        overlay = [ overlay ] ++ overlays ++ sharedOverlays;
        config = {
          allowUnfree = true;
        };
      };

      nixosSystem =
        { system ? "x86_64-linux"
        , configuration ? { }
        , modules ? [ ]
        , overlays ? [ ]
        , extraModules ? [ ]
        , specialArgs ? { }
        , ...
        }:
        let
          pkgs = (importPkgs nixos overlays system);
        in
        lib.nixosSystem {
          inherit system;
          modules = [
            configuration
            {
              nixpkgs = { inherit pkgs; };
            }
          ] ++ modules ++ extraModules;
          specialArgs = {
            inherit
              (inputs)
              unstable
              nixos
              home
              nixos-wsl;
            inherit
              username;
          } // specialArgs;
        };
    in
    {
      nixosConfigurations."albedo" = nixosSystem {
        configuration = ./hosts/albedo;
        inherit extraModules;
        overlays = [ emacs-overlay.overlay ];
      };

      nixosConfigurations."aqua" = nixosSystem {
        configuration = ./hosts/aqua;
        inherit extraModules;
      };

      nixosConfigurations."tanya" = nixosSystem {
        configuration = ./hosts/tanya;
        inherit extraModules;
      };

      nixosConfigurations."kazuma" = nixosSystem {
        configuration = ./hosts/kazuma;
        inherit extraModules;
      };

      nixosConfigurations."emilia" = nixosSystem {
        system = "aarch64-linux";
        configuration = ./hosts/emilia;
        inherit extraModules;
      };

      nixosConfigurations."rem" = nixosSystem {
        system = "aarch64-linux";
        configuration = ./hosts/rem;
        inherit extraModules;
      };

      nixosConfigurations."ram" = nixosSystem {
        system = "aarch64-linux";
        configuration = ./hosts/ram;
        inherit extraModules;
      };

      nixosConfigurations."megumin" = nixosSystem {
        configuration = ./hosts/megumin;
        inherit extraModules;
      };

      nixosConfigurations."eris" = nixosSystem {
        configuration = ./hosts/eris;
        inherit extraModules;
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
              sshUser = nixosConfig.config.deploy.sshUser;
              sshOpts = [ "-p" (builtins.toString nixosConfig.config.deploy.port) ];
              path = deploy-rs.lib.${nixosConfig.config.nixpkgs.system}.activate.nixos nixosConfig;
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
      in
      {
        devShell = import ./shell.nix { inherit pkgs inputs system; };
      });
}
