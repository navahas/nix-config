{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  zstd,
}:

# clang-format 23.1.0 extracted from the official LLVM prebuilt release.
# nixpkgs has no LLVM 23 yet (released 2026-08-25), so we wrap the upstream
# Linux binary and pull out only the clang-format tool.
stdenv.mkDerivation rec {
  pname = "clang-format";
  version = "23.1.0";

  src = fetchurl {
    url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/LLVM-${version}-Linux-X64.tar.xz";
    # Filled in from `nix-prefetch-url --type sha256` of the tarball above.
    hash = "sha256-GNow939HVoihj3cE0j+fFVrgB+2ZItvtaFCpQZ2f7Iw=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    zstd
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/clang-format "$out/bin/clang-format"
    runHook postInstall
  '';

  meta = {
    description = "LLVM ${version} clang-format tool (upstream prebuilt Linux binary)";
    homepage = "https://clang.llvm.org/docs/ClangFormat.html";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "clang-format";
  };
}
