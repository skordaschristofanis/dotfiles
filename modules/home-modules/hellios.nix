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

  _dotfiles.shell.hostAliases = {
    nix-rebuild = "sudo nixos-rebuild switch --flake ${dotfilesPath}#hellios --impure";
  };

  programs.bash.enable = true;
}
