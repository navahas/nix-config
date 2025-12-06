{ config, pkgs, lib, username, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix # Generate with nixos-generate-config
    ./packages.nix
  ];

  # Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Locale
  time.timeZone = "America/New_York"; # Adjust as needed
  i18n.defaultLocale = "en_US.UTF-8";

  # Display Manager - Keep GDM
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Shells
  programs.fish.enable = true;
  programs.bash.enable = true;
  programs.zsh.enable = true;

  # User
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
  };

  # Minimal system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];

  # Docker
  virtualisation.docker.enable = true;

  # Security
  security.sudo.wheelNeedsPassword = true;

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
