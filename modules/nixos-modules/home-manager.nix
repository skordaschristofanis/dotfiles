{ config, lib, inputs, secrets, dotfiles, ... }:
let
  cfg = config.modules.home-manager;
  host = {
    username = secrets.username;
    homeDirectory = "/home/${secrets.username}";
  };
  profile = import ../home-modules/${config.host.profile}.nix { inherit secrets host; };
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.home-manager = {
    enable = lib.mkEnableOption "home-manager configuration" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      users.${host.username} = profile;
    };
  };
}
