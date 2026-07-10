# Vortex - MBP M3 Pro (work)
{ secrets, ... }:

{
  system.primaryUser = secrets.username;
  system.stateVersion = 7;
  environment.darwinConfig = "/Users/${secrets.username}/Repos/dotfiles/hosts/darwin/vortex.nix";

  host.dotfilesPath = "/Users/${secrets.username}/Repos/dotfiles";

  modules.base.enable = true;
  modules.determinate.enable = true;
  modules.home-manager.enable = true;

  modules.homebrew = {
    enable = true;

    brews = [
    ];

    casks = [
        "1password"
        "1password-cli"
        "adobe-creative-cloud"
        "microsoft-office"
        "windows-app"
    ];

    masApps = {
    };
  };
}

