{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pciutils # lspci
    usbutils # lsusb
    glxinfo # GPU info
    vulkan-tools # vulkaninfo
    mesa
  ];

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
