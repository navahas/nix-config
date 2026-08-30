{ pkgs, lib, ... }:
# Native Tree-sitter runtime for Neovim, no plugin lua loaded.
# Parsers (.so) + queries land on runtimepath via site/pack; the
# native vim.treesitter.start (see ~/.dotfiles/nvim/lua/treesitter.lua)
# picks them up. Built per-system: Mach-O on darwin, ELF on Linux.
let
  # Add a language here and rebuild. Left = parser name nvim expects
  # (must match filetype or a vim.treesitter.language.register alias),
  # right = the nixpkgs grammar attr.
  grammars = with pkgs.tree-sitter-grammars; {
    typescript = tree-sitter-typescript;
    tsx        = tree-sitter-tsx;
    javascript = tree-sitter-javascript;
    rust       = tree-sitter-rust;
    cpp        = tree-sitter-cpp;
  };

  # Parsers from nvim-treesitter-parsers (different attr scope).
  extraGrammars = {
    nasm = pkgs.vimPlugins.nvim-treesitter-parsers.nasm;
  };

  links = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: grammar:
      "ln -s ${grammar}/parser $out/parser/${name}.so"
    ) grammars
    ++ lib.mapAttrsToList (name: grammar:
      "ln -s ${grammar}/parser/${name}.so $out/parser/${name}.so"
    ) extraGrammars
  );

  treesitter-parsers = pkgs.runCommand "nvim-treesitter-parsers" { } ''
    mkdir -p $out/parser
    ${links}
  '';
in
{
  # Parser .so files.
  home.file.".local/share/nvim/site/pack/nix/start/treesitter-parsers".source = treesitter-parsers;
  # Highlight/indent/fold queries from nvim-treesitter (queries only, no lua).
  home.file.".local/share/nvim/site/pack/nix/start/treesitter-queries".source =
    "${pkgs.vimPlugins.nvim-treesitter}/runtime";
}
