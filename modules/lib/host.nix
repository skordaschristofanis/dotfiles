{ lib, ... }:
{
  options.host = {
    profile = lib.mkOption {
      type = lib.types.str;
      description = "Home-manager profile (modules/home-modules/<profile>.nix).";
    };

    dotfilesPath = lib.mkOption {
      type = lib.types.str;
      description = "Absolute path to the dotfiles checkout (required for config submodules).";
    };
  };
}
