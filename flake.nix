{
    description = "Nix config";

    inputs = {
    # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Flakes
        flake-parts.url = "github:hercules-ci/flake-parts";
        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # Home manager
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    # MacOS
        nix-darwin = {
            url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    # General
        nix-flatpak.url = "github:gmodena/nix-flatpak";
        hardware.url = "github:nixos/nixos-hardware";
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ flake-parts, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            imports = [
                ./modules/wiring/hosts.nix
            ];

            systems = [
                "aarch64-darwin"
                    "x86_64-linux"
            ];
        };
}

