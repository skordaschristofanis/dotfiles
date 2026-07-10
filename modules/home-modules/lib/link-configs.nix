{ dotfiles, configs }:
{ lib, config, ... }:
let
  dotfilesPath = toString dotfiles;
in
{
  xdg.configFile = lib.genAttrs configs (name: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/${name}";
  });
}
