{ config, lib, pkgs, ... }:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop environment configuration" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.displayManager.ly.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "amdgpu" ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
