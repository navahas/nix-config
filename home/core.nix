{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      # Editors
      neovim
      helix
      vim
      unzip

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
      clang
      cmake
      rustup
      typescript-go

      # Network & Cloud Tools
      cloudflared

      fastfetch

      hexyl # hex viewer
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # clang-format 23.1.0 wrapped from the upstream LLVM prebuilt binary.
      # hiPrio so it wins the `clang-format` collision against clang-tools.
      (lib.hiPrio (pkgs.callPackage ../pkgs/clang-format-23.nix { }))
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # Darwin-only / heavy packages excluded from VPS profile
      nmap
      grpcurl

      # lima
      qemu # qemu_full

      # Container & Kubernetes Tools
      docker-compose
      kubernetes-helm
      kind
      minikube

      ffmpeg
      imagemagick

      hyperfine # benchmarking
      wrk # HTTP benchmarking
      k6 # load testing

      wabt # WebAssembly Binary Toolkit
      kubo # IPFS implementation (formerly go-ipfs)
      libpq # PostgreSQL client
    ];
}
