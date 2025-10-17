{
    description = "Navahas nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-homebrew.url = "github:zhaofengli/nix-homebrew";

        # Optional: Declarative tap management
        homebrew-core = {
            url = "github:homebrew/homebrew-core";
            flake = false;
        };
        homebrew-cask = {
            url = "github:homebrew/homebrew-cask";
            flake = false;
        };
    };

    outputs = inputs@{ self, nixpkgs, darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }:
        let
            username = "cnavajas";
            system = "aarch64-darwin";
            # hostname = "";
            option = "setup";

            specialArgs =
                inputs
                // {
                    inherit username option;
                };
        in {
            darwinConfigurations."${option}" = darwin.lib.darwinSystem {
                inherit system specialArgs;
                modules = [
                    ./modules/nix-core.nix
                    ./modules/system.nix
                    ./modules/apps.nix
                ];
            };
            formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
        };
}
