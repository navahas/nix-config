{
  description = "Navahas nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      nix-homebrew,
      neovim-nightly-overlay,
      ...
    }:
    let
      # Platform configs
      darwinConfig = {
        username = "navahas";
        system = "aarch64-darwin";
      };

      linuxConfig = {
        username = "cnavajas";
        system = "x86_64-linux";
        hostname = "fedora-workstation";
      };

    in
    {
      # === PHASE A: HOME-MANAGER STANDALONE (Immediate Use on Fedora) ===
      homeConfigurations."${linuxConfig.username}@fedora" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = linuxConfig.system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          username = linuxConfig.username;
          isDarwin = false;
        };
        modules = [ ./home ];
      };

      # === DARWIN CONFIGURATION (Updated paths) ===
      darwinConfigurations."setup" = darwin.lib.darwinSystem {
        system = darwinConfig.system;
        specialArgs = inputs // { username = darwinConfig.username; };
        modules = [
          ./modules/nix-core.nix
          ./modules/darwin/system.nix
          ./modules/darwin/apps.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.hostPlatform = darwinConfig.system;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = darwinConfig.username;
              isDarwin = true;
            };
            home-manager.users.${darwinConfig.username} = import ./home;
          }
        ];
      };

      # === PHASE B: NIXOS CONFIGURATION (Future Use) ===
      nixosConfigurations."setup-linux" = nixpkgs.lib.nixosSystem {
        system = linuxConfig.system;
        specialArgs = inputs // {
          username = linuxConfig.username;
          hostname = linuxConfig.hostname;
        };
        modules = [
          ./modules/nix-core.nix
          ./modules/linux/configuration.nix
          ./modules/linux/hyprland.nix
          ./modules/linux/packages.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.hostPlatform = linuxConfig.system;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = linuxConfig.username;
              isDarwin = false;
            };
            home-manager.users.${linuxConfig.username} = import ./home;
          }
        ];
      };

      # Formatter for both platforms
      formatter = {
        ${darwinConfig.system} = nixpkgs.legacyPackages.${darwinConfig.system}.nixfmt-rfc-style;
        ${linuxConfig.system} = nixpkgs.legacyPackages.${linuxConfig.system}.nixfmt-rfc-style;
      };
    };
}
