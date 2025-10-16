{
    description = "Navahas nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

    outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
        let
            configuration = { config, pkgs, ... }: {
                # List packages installed in system profile. To search by name, run:
                # $ nix-env -qaP | grep wget
                environment.systemPackages =
                    [ 
                        # pkgs.zed-editor
                        # pkgs.nixfmt-rfc-style
                        pkgs.vim
                    ];

                nix.settings.experimental-features = "nix-command flakes";
                programs.zsh.enable = true;
                # programs.fish.enable = true;

                # Set Git commit hash for darwin-version.
                system.configurationRevision = self.rev or self.dirtyRev or null;

                # $ darwin-rebuild changelog
                # Used for backwards compatibility, please read the changelog before changing.
                system.stateVersion = 6;
                nixpkgs.hostPlatform = "aarch64-darwin";

                system.activationScripts.applications.text = let
                    env = pkgs.buildEnv {
                        name = "system-applications";
                        paths = config.environment.systemPackages;
                        pathsToLink = "/Applications";
                    };
                in
                    pkgs.lib.mkForce ''
                      # Set up applications.
                      echo "setting up /Applications..." >&2
                      rm -rf /Applications/Nix\ Apps
                      mkdir -p /Applications/Nix\ Apps
                      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
                      while read -r src; do
                        app_name=$(basename "$src")
                        echo "copying $src" >&2
                        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
                      done
               '';

                system.activationScripts.postActivation.text = ''
                    echo "#setup -----> darwin flake ready" >&2
                '';
            };
        in
            {
            # Build darwin flake using:
            # $ darwin-rebuild build --flake .#setup
            darwinConfigurations."setup" = nix-darwin.lib.darwinSystem {
                modules = [
                    configuration 
                    nix-homebrew.darwinModules.nix-homebrew
                    {
                        nix-homebrew = {
                            # Install Homebrew under the default prefix
                            enable = true;

                            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                            enableRosetta = true;

                            # User owning the Homebrew prefix
                            user = "usuario00";

                            # Automatically migrate existing Homebrew installations
                            autoMigrate = true;
                        };
                    }
                ];
            };

        };
}
