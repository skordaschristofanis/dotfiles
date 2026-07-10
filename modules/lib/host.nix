{ lib, ... }:
{
  options.host = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Primary user for this host.";
    };

    profile = lib.mkOption {
      type = lib.types.str;
      description = "Home-manager profile (modules/home-modules/<profile>.nix).";
    };
  };
}
