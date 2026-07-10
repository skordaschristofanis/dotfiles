{ config, lib, pkgs, secrets, ... }:
let
  cfg = config.modules.base;
  user = secrets.username;
in
{
  options.modules.base = {
    enable = lib.mkEnableOption "base NixOS configuration" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;

    time.timeZone = "America/Chicago";

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        tree
      ];
    };

    programs.firefox.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      code-cursor
      neovim
      ripgrep
      bat
      protonplus
      alacritty
      waybar
      kitty
      dunst
      libnotify
      rofi
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
