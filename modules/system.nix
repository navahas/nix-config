{ self, pkgs, ... }:
#----| macOS System configuration
# All the configuration options are documented here:
# https://nix-darwin.github.io/nix-darwin/manual/index.html#sec-options
{
    system = {
        # Used for backwards compatibility, please read the changelog before changing.
        # > darwin-rebuild changelog
        stateVersion = 6;
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
    };
    security.pam.services.sudo_local.touchIdAuth = true;
    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true;
}
