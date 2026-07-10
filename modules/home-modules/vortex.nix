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

  home.packages = with pkgs; [
    claude-code
    firefox
  ];

  programs.zsh = {
      enable = true;
      shellAliases = {
          cat = "bat";
          ll = "eza -lah --group-directories-first --sort=name";
          ls = "eza";
          nix-rebuild = "sudo -H nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/Repos/dotfiles#vortex --impure";
          sudo = "sudo -E";
          vim = "nvim";
      };
  };
}
