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
    zed-editor
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      sudo = "sudo -E";
      vim = "nvim";
      cat = "bat";
      nix-rebuild = "sudo nixos-rebuild switch --flake /repos/dotfiles#hellios --impure";
    };
    initExtra = ''
      export OCL_ICD_VENDORS="/run/opengl-driver/etc/OpenCL/vendors"
      export LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ]}:''${LD_LIBRARY_PATH:-}"
    '';
  };
}
