{ config, lib, inputs, ... }:
let
  cfg = config.modules.flatpak;
in
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  options.modules.flatpak = {
    enable = lib.mkEnableOption "flatpak configuration" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "com.discordapp.Discord"
        "com.makemkv.MakeMKV"
        "org.kde.dragonplayer"
      ];
    };
  };
}
