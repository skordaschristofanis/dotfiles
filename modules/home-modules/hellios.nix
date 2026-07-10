{ secrets, host, dotfiles }:
{ config, pkgs, ... }:

{
  imports = [
    (import ./base.nix { inherit secrets host; })
    (import ./lib/link-configs.nix {
      inherit dotfiles;
      configs = [ "nvim" ];
    })
  ];
}
