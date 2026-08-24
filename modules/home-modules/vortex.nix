{ secrets, host, dotfilesPath }:
{ config, pkgs, ... }:

{
  imports = [
    (import ./base.nix { inherit secrets host; })
    (import ./lib/link-configs.nix {
      inherit dotfilesPath;
      configs = [ "nvim" ];
    })
  ];

  home.packages = with pkgs; [
    claude-code
    firefox
    proton-vpn
    zed-editor
  ];

  programs.zsh = {
      enable = true;
      shellAliases = {
          cat = "bat";
          ll = "eza -lah --group-directories-first --sort=name";
          ls = "eza";
          nix-rebuild = "sudo -H nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/Repos/dotfiles#vortex --impure";
          sudo = "sudo -E";
          tm = "tmux new-session -A -s dev";
          tree = "tree -C";
          vim = "nvim";
      };

      initContent = ''
      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
              . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
          else
              export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<
    '';
  };
}
