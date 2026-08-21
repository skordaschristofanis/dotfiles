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
        "cursor"
        "cursor-cli"
        "github"
        "grammarly-desktop"
        "microsoft-office"
        "microsoft-teams"
        "miniconda"
        "windows-app"
        "zoom"
    ];

    masApps = {
    };
  };

  system.activationScripts.calendarDelegateReminder.text = ''
    echo ""
    echo "REMINDER: Calendar delegate accounts must be added manually."
    echo "  Calendar → Settings → Accounts → <your Exchange account> → Delegation → +"
    echo ""
    echo "  Delegate accounts:"
    ${builtins.concatStringsSep "\n" (map (a: "  echo \"    ${a}\"") secrets.calendar.delegateAccounts)}
    echo ""
  '';
}

