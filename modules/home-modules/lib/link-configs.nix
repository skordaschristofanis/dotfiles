{ configs }:
{ lib, ... }:

{
  home.file = lib.foldl' (acc: name: acc // {
    ".config/${name}" = {
      source = ../../../config/${name};
      recursive = true;
    };
  }) { } configs;
}
