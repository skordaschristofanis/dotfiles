# Vortex - MBP M3 Pro (work)
{ secrets, ... }:

{
  system.primaryUser = secrets.username;
  system.stateVersion = 7;
  environment.darwinConfig = "/Users/${secrets.username}/Repos/dotfiles/hosts/darwin/vortex.nix";

  modules.base.enable = true;
  modules.determinate.enable = true;
}
