{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Wayland/Hyprland tools
    waybar
    wofi # Application launcher
    dunst # Notification daemon
    swaylock # Screen locker
    swayidle # Idle management

    # Hyprland utilities
    hyprpaper # Wallpaper daemon
    hypridle # Idle daemon for Hyprland
    hyprpicker # Color picker

    # Screenshot/recording
    grim # Screenshot tool
    slurp # Region selector
    wl-clipboard # Wayland clipboard utilities

    # Other Wayland tools
    wlr-randr # Display management
    wtype # xdotool alternative for Wayland
  ];

  # XDG portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Fonts for Waybar
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "UbuntuMono" ]; })
    noto-fonts
    noto-fonts-emoji
  ];
}
