{ configs, dotfilesPath }:
{ lib, config, ... }:

{
  home.file = lib.foldl' (acc: name: acc // {
    ".config/${name}".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/${name}";
  }) { } configs;
}
