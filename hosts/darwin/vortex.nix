# Vortex - MBP M3 Pro
{ inputs, pkgs, ... }:

{
    modules = {};
    environment.darwinConfig = "$HOME/Repos/dotfiles/hosts/darwin/vortex.nix";
}
