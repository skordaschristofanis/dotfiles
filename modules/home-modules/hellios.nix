{ secrets, host }:
{ config, pkgs, ... }:

{
  imports = [
    (import ./base.nix { inherit secrets host; })
    (import ./lib/link-configs.nix {
      configs = [ "nvim" ];
    })
  ];
}
