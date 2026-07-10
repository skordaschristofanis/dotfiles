{ dotfiles, configs }:
{ lib, ... }:

{
  xdg.configFile = lib.genAttrs configs (name: {
    source = "${dotfiles}/config/${name}";
    recursive = true;
  });
}
