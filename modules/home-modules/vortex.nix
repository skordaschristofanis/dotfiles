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
    proton-vpn
  ];

  _dotfiles.shell.hostAliases = {
    nix-rebuild = "sudo -H nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ${dotfilesPath}#vortex --impure";
  };

  programs.zsh.enable = true;
}
