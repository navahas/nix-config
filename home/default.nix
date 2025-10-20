{ username, config, lib, ... }:
{
  # import sub modules
  imports = [
    # ./shell.nix
    ./core.nix
    ./node.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";

    # Add home-manager user packages to PATH
    sessionPath = [
      "/etc/profiles/per-user/${config.home.username}/bin"
    ];
  };

  # Dotfiles management - symlink to existing dotfiles
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.dotfiles/tmux/.tmux.conf";

  # Activation script to run after home-manager finishes
  home.activation.postActivation = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    echo "===========================================" >&2
    echo "#home-manager -----> user environment ready" >&2
    echo "===========================================" >&2
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
