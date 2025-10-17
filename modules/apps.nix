{ pkgs, config, username, nix-homebrew, ... }:
{
    imports = [
        nix-homebrew.darwinModules.nix-homebrew
    ];

    # List packages installed in system profile. To search by name, run:
    # > nix-env -qaP | grep wget
    environment.systemPackages =
        [
            # pkgs.zed-editor
            # pkgs.nixfmt-rfc-style
            pkgs.vim
        ];
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

    nix-homebrew = {
        # Install Homebrew under the default prefix
        enable = true;
        enableRosetta = false;
        user = username;
    };

    system.activationScripts.postActivation.text = ''
                    echo "#setup -----> darwin flake ready" >&2
                    '';
}
