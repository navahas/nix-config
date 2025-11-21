{ pkgs, ... }:
let
  tsgo = pkgs.writeShellScriptBin "tsgo" ''
    ${pkgs.nodejs_24}/bin/npx @typescript/native-preview "$@"
  '';
in
{
  home.packages = with pkgs; [
    nodejs_24
    # nodePackages.npm # included with nodejs
    # nodePackages.pnpm # alternative package manager
    # nodePackages.yarn # alternative package manager
    claude-code
    codex
    # gemini-cli

    # not working properly atm
    tsgo
  ];
}
