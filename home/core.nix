{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Editors
    helix
    vim

    # Shell & CLI Utilities
    fish
    nushell
    bat # better cat
    eza # better ls
    fzf # fuzzy finder
    ripgrep # better grep
    jq # JSON processor
    yazi # terminal file manager
    tmux
    btop # system monitor
    htop
    dust # better du
    tree

    # Development Tools
    git
    gh # GitHub CLI
    lazygit
    clang-tools
    cmake
    rustup

    # Network & Cloud Tools
    cloudflared
    nmap
    grpcurl

    # Container & Kubernetes Tools
    docker-compose
    kubernetes-helm
    kind
    minikube

    # Media & Image Tools
    ffmpeg
    imagemagick

    # System Information
    fastfetch

    # Performance & Testing
    hyperfine # benchmarking
    wrk # HTTP benchmarking
    k6 # load testing

    # File & Hex Tools
    hexyl # hex viewer

    # WebAssembly Tools
    wabt # WebAssembly Binary Toolkit

    # IPFS
    kubo # IPFS implementation (formerly go-ipfs)

    # Database Tools
    libpq # PostgreSQL client
  ];
}
