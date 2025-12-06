# Hardware configuration - generate with nixos-generate-config when installing NixOS
# For now, this is a placeholder for Phase B
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # TODO: Generate this file when installing NixOS:
  # sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
  #
  # This should include:
  # - boot.initrd.availableKernelModules
  # - boot.kernelModules
  # - fileSystems
  # - swapDevices
  # - networking.useDHCP settings
}
