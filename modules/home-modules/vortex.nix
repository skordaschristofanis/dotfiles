{ secrets, host, dotfilesPath }:
{ config, pkgs, ... }:

{
  imports = [ (import ./base.nix { inherit secrets host; }) ];

  # Work machine extras
}
