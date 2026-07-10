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

  programs.zsh = {
      enable = true;
      shellAliases = {
          sudo = "sudo -E";
          vim = "nvim";
          cat = "bat";
          nix-rebuild = "sudo -H nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/Repos/dotfiles#vortex --impure";
      };
  };
}
