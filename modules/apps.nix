{
  pkgs,
  config,
  username,
  nix-homebrew,
  ...
}:
{
  imports = [
    nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = false;

    # User owning the Homebrew prefix
    user = username;

    # Automatically migrate existing Homebrew installations
    autoMigrate = true;
  };

  # List packages installed in system profile. To search by name, run:
  # > nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # System-level Editors & Terminal Tools
    ghostty-bin # terminal emulator

    # Nix Development Tools (system-level for IDE/LSP support)
    nixd # nix language server
    nixfmt # nix formatter
    nixfmt-tree # nix formatter

    # Core System Utilities
    coreutils # GNU core utilities
    gnupg # encryption/signing
    inetutils # network utilities
    rsync # file synchronization
    pkgconf # pkg-config replacement

    # Development Libraries (consider moving to per-project devShells)
    # boost
    # jpeg
    # libuv
    # lmdb
    # rocksdb
  ];

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
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

  # Homebrew configuration (for GUI apps and packages not in nixpkgs)
  homebrew = {
    enable = true;

    taps = [ "nikitabobko/tap" ];

    # Casks - GUI Applications
    casks = [
      "aerospace"
      "raycast"
      "brave-browser"
      # "font-jetbrains-mono-nerd-font"
      # "font-ubuntu-nerd-font"
      "karabiner-elements"
      "keycastr"
      # "kitty"
      # "ngrok"
      "obs"
      "orbstack"
      "rectangle"
      "stats"
      # "visual-studio-code"
      "zed"
      "wireshark-app"
      "obsidian"
      "google-chrome"
      "claude"
      "spotify"
      "discord"
    ];

    # Brews - CLI tools not available in nixpkgs
    brews = [
      "lazydocker"
      # "mongosh"
      "lima"
      "lima-additional-guestagents"
      "socket_vmnet" # sudo brew services start socket_vmnet
      "gforth"
    ];

    onActivation = {
      cleanup = "none";
      autoUpdate = false;
      upgrade = true;
    };
  };

  system.activationScripts.postActivation.text = ''
    echo "===========================================" >&2
    echo "#modules -----> apps configured " >&2
    echo "#nix-darwin -----> build ready " >&2
    echo "===========================================" >&2
  '';
}
