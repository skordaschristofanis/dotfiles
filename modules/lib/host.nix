{ lib, ... }:
{
  options.host = {
    profile = lib.mkOption {
      type = lib.types.str;
      description = "Home-manager profile (modules/home-modules/<profile>.nix).";
    };
  };
}
