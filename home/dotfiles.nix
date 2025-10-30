{ config, ... }:
{
  # Symlink dotfiles from $HOME/.dotfiles expected locations
  # This allows editing configs directly without needing to rebuild
  home.file = {
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

    ".config/aerospace".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/aerospace";

    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/ghostty";

    ".config/eza".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/eza";
  };

  # Note: No programs.*.enable here since configs are managed externally via symlinks
  # Shells are enabled at system level (modules/system.nix)
  # Packages are installed via home.packages (home/core.nix)
}
