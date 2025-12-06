{ config, lib, isDarwin ? true, ... }:
{
  # Symlink dotfiles from $HOME/.dotfiles expected locations
  # This allows editing configs directly without needing to rebuild
  home.file = {
    # Cross-platform dotfiles
    ".config/fish".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fish";

    ".bashrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/bash/.bashrc";

    ".config/nvim010".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim010";

    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";

    ".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tmux/.tmux.conf";

    ".local/scripts".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/scripts";

    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/ghostty";

    ".config/eza".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/eza";
  }
  # Darwin-only dotfiles
  // lib.optionalAttrs isDarwin {
    ".config/aerospace".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/aerospace";
  }
  # Linux-only dotfiles (Hyprland/Waybar from .dotfiles Linux branch)
  // lib.optionalAttrs (!isDarwin) {
    ".config/hypr".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr";

    ".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/waybar";
  };

  # Note: No programs.*.enable here since configs are managed externally via symlinks
  # Shells are enabled at system level (modules/system.nix)
  # Packages are installed via home.packages (home/core.nix)
}
