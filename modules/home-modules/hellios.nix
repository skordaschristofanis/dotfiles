{ secrets, host, dotfilesPath }:
{ config, pkgs, ... }:

{
  imports = [
    (import ./base.nix { inherit secrets host; })
    (import ./lib/link-configs.nix {
      inherit dotfilesPath;
      configs = [ "nvim" ];
    })
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      sudo = "sudo -E";
      vim = "nvim";
      cat = "bat";
      nix-rebuild = "sudo nixos-rebuild switch --flake /repos/dotfiles#hellios --impure";
    };
  };
}
