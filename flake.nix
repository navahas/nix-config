{
    description = "Navahas nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    };

    outputs = inputs@{ self, nixpkgs, darwin, nix-homebrew, ... }:
        let
            username = "usuario00";
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
