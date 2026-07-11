{ lib, config, ... }:
let
  cfg = config._dotfiles.shell;
  commonAliases = (import ./shell-aliases.nix).common;
  allAliases = commonAliases // cfg.hostAliases;
in
{
  options._dotfiles.shell.hostAliases = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = "Host-specific shell aliases merged with common aliases.";
  };

  config = {
    programs.bash.shellAliases = lib.mkIf config.programs.bash.enable allAliases;
    programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable allAliases;
  };
}
