{ secrets, host }:
{ config, pkgs, ... }:

{
  home.username = host.username;
  home.homeDirectory = host.homeDirectory;
  home.stateVersion = "26.05";
  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    git
    neovim
    ripgrep
    tree
    uv
    wget
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = secrets.git.name;
        email = secrets.git.email;
      };
      init.defaultBranch = "main";

      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = secrets.ssh.allowedSignersFile;
    };
    signing = {
      key = secrets.ssh.signingKey;
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        ForwardAgent = "no";
        HashKnownHosts = "yes";
        ServerAliveInterval = 0;
        IdentitiesOnly = true;
      };

      "github.com" = {
        User = "git";
        IdentityFile = secrets.ssh.identityFile;
      };

      "gitlab.com" = {
        User = "git";
        IdentityFile = secrets.ssh.identityFile;
      };
    };
  };
}
