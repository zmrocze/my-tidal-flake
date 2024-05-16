{
  description = "Flake template: flake-parts + pre-commit-hooks + devshell + pkgsConfig";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-lib.url = "github:zmrocze/nix-lib";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    tidal = {
      # url = "github:mitchmindtree/tidalcycles.nix";
      url = "github:zmrocze/tidalcycles.nix?ref=karol/superdirt-install";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haskellNix = {
      url = "github:input-output-hk/haskell.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, tidal, nixpkgs, flake-parts, my-lib, ... }:
    let
      myLib = my-lib.lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          ./nix/pre-commit.nix
          ./nix/shell.nix
          ./nix/pkgs.nix
          ./nix/haskell.nix
        ];
        systems = [ "x86_64-linux" ];
        perSystem = { inputs', ... }:
          {
            devShells.tidal = inputs'.tidal.devShells.tidal;
          };
      };
}
