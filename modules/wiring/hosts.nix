{ inputs, self, ... }:
let
mkNixos = { system, hostPath }:
inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
        inherit inputs;
        outputs = self;
    };
    modules = [
        hostPath
        { imports = builtins.attrValues self.nixosModules; }
    ];
};

mkDarwin = { hostPath }:
inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
        inherit inputs;
        outputs = self;
        pkgs-unstable = import inputs.nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
        };
    };
    modules = [
        hostPath
        { imports = builtins.attrValues self.darwinModules; }
    ];
};
in
{
    flake = {
        darwinModules = {
            base = import ../darwin-modules/base.nix;
            determinate = import ../darwin-modules/determinate.nix;
        };

        darwinConfigurations = {
            vortex = mkDarwin { hostPath = ../../hosts/darwin/vortex.nix; };
        };
    };
}

