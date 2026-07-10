{ secrets, host, dotfiles }:
{ config, pkgs, ... }:

{
  imports = [ (import ./base.nix { inherit secrets host; }) ];

  # Work machine extras
}
