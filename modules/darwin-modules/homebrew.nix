{ config, lib, ... }:
let
  cfg = config.modules.homebrew;
in
{
  options.modules.homebrew = {
    enable = lib.mkEnableOption "Homebrew management via nix-darwin" // {
      default = false;
    };

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Homebrew formulae to install.";
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Homebrew casks to install.";
    };

    masApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = { };
      description = "Mac App Store apps to install (name = id).";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };

      brews = cfg.brews;
      casks = cfg.casks;
      masApps = cfg.masApps;
    };
  };
}
