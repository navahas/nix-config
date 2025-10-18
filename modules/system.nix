{ self, pkgs, username, ... }:
#----| macOS System configuration
# All the configuration options are documented here:
# https://nix-darwin.github.io/nix-darwin/manual/index.html#sec-options
{
    system = {
        primaryUser = username;
        # Used for backwards compatibility, please read the changelog before changing.
        # > darwin-rebuild changelog
        stateVersion = 6;
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    # Shell Programs Configuration
    # Enable modern shells from Nix instead of ancient macOS defaults
    # (macOS still ships Bash 3.x due to GPL licensing)
    programs.bash.enable = true;
    programs.fish.enable = true;
    programs.zsh.enable = true;

    # User Configuration
    users.users.${username} = {
        home = "/Users/${username}";

        # Default login shell - uncomment ONE of the following:
        # shell = pkgs.bash;     # Modern Bash (recommended for compatibility)
        shell = pkgs.fish;              # Fish shell (user-friendly, modern features)
        # shell = pkgs.zsh;               # Zsh (macOS default, but Nix version is newer)

        # After changing the shell, run:
        # darwin-rebuild switch --flake .#setup
        # Then restart your terminal or run:
        # exec $SHELL
        # sudo sh -c 'echo /run/current-system/sw/bin/fish >> /etc/shells'
        # chsh -s /run/current-system/sw/bin/fish
    };
}
