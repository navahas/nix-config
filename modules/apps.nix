{ pkgs, config, username, nix-homebrew, ... }:
let
    # Neovim 0.10.4 lives in this nixpkgs commit
    nvim0104 =
        (import (builtins.fetchTarball {
            # To find the hash version: https://lazamar.co.uk/nix-versions/
            # for Neovim v0.10.4;
            url = "https://github.com/NixOS/nixpkgs/archive/c5dd43934613ae0f8ff37c59f61c507c2e8f980d.tar.gz";

            # To get hash of the pkg we can either build and copy from mismatch or prefetch as follows:
            # nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/<commit>.tar.gz
            #
            # Example with Neovim:
            # nix-prefetch-url \
            #   --unpack https://github.com/NixOS/nixpkgs/archive/c5dd43934613ae0f8ff37c59f61c507c2e8f980d.tar.gz
            #
            # > path is '/nix/store/2d8d681fzrs4gxmzawah9qgpkfhic0xm-c5dd43934613ae0f8ff37c59f61c507c2e8f980d.tar.gz'
            # > 1cpw3m45v7s7bm9mi750dkdyjgd2gp2vq0y7vr3j42ifw1i85gxv
            sha256 = "1cpw3m45v7s7bm9mi750dkdyjgd2gp2vq0y7vr3j42ifw1i85gxv";
        }) {
                # make sure we build for your current platform
                system = pkgs.stdenv.hostPlatform.system;
            }).neovim;
in {
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
        # Editors & Terminal Tools
        nvim0104
        vim
        helix

        # Shell & CLI Utilities
        # bash           # nonInteractive
        fish
        nushell
        bat              # better cat
        eza              # better ls
        fzf              # fuzzy finder
        ripgrep          # better grep
        jq               # JSON processor
        yazi             # terminal file manager
        tmux
        btop             # system monitor
        htop
        dust             # better du
        tree

        # Development Tools
        git
        gh               # GitHub CLI
        lazygit
        clang-tools
        cmake

        # Network & Cloud Tools
        cloudflared
        gnupg
        nmap
        inetutils
        rsync
        grpcurl

        # Container & Kubernetes Tools
        docker-compose
        kubernetes-helm
        kind
        minikube
        # lazydocker    # might need to check if available

        # Build & Development Libraries
        coreutils
        # gnugrep
        pkgconf

        # Media & Image Tools
        ffmpeg
        imagemagick

        # System Information
        fastfetch

        # Performance & Testing
        hyperfine        # benchmarking
        wrk              # HTTP benchmarking
        k6               # load testing

        # File & Hex Tools
        hexyl            # hex viewer

        # WebAssembly Tools
        wabt             # WebAssembly Binary Toolkit

        # IPFS
        kubo             # IPFS implementation (formerly go-ipfs)

        # Database Tools
        libpq            # PostgreSQL client
        # mongosh        # MongoDB shell - may need homebrew if not available

        # Development Libraries (consider moving to per-project devShells)
        # boost
        # jpeg
        # libuv
        # lmdb
        # rocksdb
    ];

    system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
        };
    in pkgs.lib.mkForce ''
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
            # "font-jetbrains-mono-nerd-font"
            # "font-ubuntu-nerd-font"
            "karabiner-elements"
            "keycastr"
            # "kitty"
            "ngrok"
            "obs"
            "orbstack"
            "rectangle"
            "stats"
            # "visual-studio-code"
            "wireshark-app"
        ];

        # Brews - CLI tools not available in nixpkgs
        brews = [
            "lazydocker"      # jesseduffield/lazydocker/lazydocker
            # "mongosh"         # MongoDB shell
            # "lima"            # Linux virtual machines
        ];

        onActivation = {
            cleanup = "zap";
            autoUpdate = false;
            upgrade = true;
        };
    };

    system.activationScripts.postActivation.text = ''
                    echo "#setup -----> darwin flake ready" >&2
                    '';
}
