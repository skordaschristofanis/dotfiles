# Vortex - MBP M3 Pro (work)
{ config, ... }:

{
  host.username = "chris";

  system.primaryUser = config.host.username;
  system.stateVersion = 7;
  environment.darwinConfig = "/Users/${config.host.username}/Repos/dotfiles/hosts/darwin/vortex.nix";

  modules.base.enable = true;
  modules.determinate.enable = true;
}
