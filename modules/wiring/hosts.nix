{ inputs, self, ... }:
let
  loadSecrets = import ../lib/secrets.nix;

  mkNixos = { system, hostName, hostPath }:
    let
      secrets = loadSecrets { inherit hostName system; };
      dotfiles = self;
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs secrets;
        outputs = self;
        dotfiles = self;
      };
      modules = [
        ../lib/host.nix
        { host.profile = hostName; }
        hostPath
        { _module.args = { inherit secrets dotfiles; }; }
        { imports = builtins.attrValues self.nixosModules; }
      ];
    };

  mkDarwin = { hostName, hostPath }:
    let
      system = "aarch64-darwin";
      secrets = loadSecrets { inherit hostName system; };
      dotfiles = self;
    in
    inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs secrets;
        outputs = self;
        dotfiles = self;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
      modules = [
        ../lib/host.nix
        { host.profile = hostName; }
        hostPath
        { _module.args = { inherit secrets dotfiles; }; }
        { imports = builtins.attrValues self.darwinModules; }
      ];
    };
in
{
  flake = {
    nixosModules = {
      base = import ../nixos-modules/base.nix;
      desktop = import ../nixos-modules/desktop.nix;
      gaming = import ../nixos-modules/gaming.nix;
      flatpak = import ../nixos-modules/flatpak.nix;
      home-manager = import ../nixos-modules/home-manager.nix;
    };

    darwinModules = {
      base = import ../darwin-modules/base.nix;
      determinate = import ../darwin-modules/determinate.nix;
    };

    nixosConfigurations = {
      hellios = mkNixos {
        system = "x86_64-linux";
        hostName = "hellios";
        hostPath = ../../hosts/nixos/hellios/default.nix;
      };
    };

    darwinConfigurations = {
      vortex = mkDarwin {
        hostName = "vortex";
        hostPath = ../../hosts/darwin/vortex.nix;
      };
    };
  };
}
