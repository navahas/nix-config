{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_24
    # nodePackages.npm # included with nodejs
    # nodePackages.pnpm # alternative package manager
    # nodePackages.yarn # alternative package manager
    claude-code
    codex
    gemini-cli
  ];

  home.file.".config/npm/package.json".text = builtins.toJSON {
    dependencies = {
      "@typescript/native-preview" = "latest";
    };
  };

  # home.activationAction
  # - https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
  # Optional: auto-run install once
  home.activation.installNodeDeps = pkgs.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    npm install -g --prefix ~/.local/npm ~/.config/npm/package.json
  '';

  home.sessionPath = [ "~/.local/npm/bin" ];
}
