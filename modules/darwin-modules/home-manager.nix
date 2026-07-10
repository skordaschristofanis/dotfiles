{ config, lib, inputs, secrets, ... }:
let
  cfg = config.modules.home-manager;
  host = {
    username = secrets.username;
    homeDirectory = "/Users/${secrets.username}";
  };
  profile = import ../home-modules/${config.host.profile}.nix {
    inherit secrets host;
    dotfilesPath = config.host.dotfilesPath;
  };
in
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

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
      users.${host.username} = { pkgs, ... }: {
        imports = [ profile ];
        home.homeDirectory = lib.mkForce host.homeDirectory;
      };
    };
  };
}
