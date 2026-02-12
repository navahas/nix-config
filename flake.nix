{
  description = "Navahas nix-darwin system flake";

  inputs = {
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # home-manager, used for managing user configuration
    home-manager = {
      # url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim nightly overlay for 0.12-dev
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
      username = "navahas";
      localSystem = "aarch64-darwin";
      # hostname = "";
      option = "setup";

      specialArgs = inputs // {
        inherit username option;
      };
    in
    {
      darwinConfigurations."${option}" = darwin.lib.darwinSystem {
        inherit specialArgs;
        system = localSystem;
        modules = [
          { nix.enable = false; }
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./home;
          }

        ];
      };
      formatter.${localSystem} = nixpkgs.legacyPackages.${localSystem}.nixfmt-rfc-style;
    };
}
