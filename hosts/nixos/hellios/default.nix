# Hellios - AMD desktop (home)
{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "hellios";
  system.stateVersion = "26.05";

  host.dotfilesPath = "/repos/dotfiles";

  modules.base.enable = true;
  modules.desktop.enable = true;
  modules.gaming.enable = true;
  modules.flatpak.enable = true;
  modules.home-manager.enable = true;
}
