# Vortex - MBP M3 Pro
{ inputs, pkgs, ... }:

{
    system.primaryUser = builtins.getEnv "USER";
    system.stateVersion = 7;
    environment.darwinConfig = "$HOME/Repos/dotfiles/hosts/darwin/vortex.nix";
}
