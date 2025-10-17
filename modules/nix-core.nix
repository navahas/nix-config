{ pkgs, lib, nixpkgs, ... }:
{

    nixpkgs.hostPlatform = "aarch64-darwin";

    nix = {
        # Determinate uses its own daemon to manage the Nix installation that
        # conflicts with nix-darwin's native Nix management.
        #
        # set this to false if you're using Determinate Nix.
        # NOTE: Turning off this option will invalidate all of the following nix configurations,
        # and you will need to manually modify /etc/nix/nix.custom.conf to add the corresponding parameters.
        # enable = true;
        package = pkgs.nix;
        settings = {
            experimental-features = "nix-command flakes";
            substituters = [
                "https://cache.nixos.org"
                "https://nix-community.cachix.org"
            ];
            trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURZ5+7Y6Z1GU3ZxZ9WS4g="
                "nix-community.cachix.org-1:6NCHdD59X431o0gWypbMrAURZ5+7Y6Z1GU3ZxZ9WS4g="
            ];
            # builders-use-substitutes = true;

            # Disable auto-optimise-store because of this issue:
            #   https://github.com/NixOS/nix/issues/7273
            # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
            # auto-optimise-store = false;
        };

        # Garbage Collection weekly to keep disk usage low
        gc = {
            automatic = lib.mkDefault true;
            options = lib.mkDefault "--delete-older-than 7d";
        };
    };
}
