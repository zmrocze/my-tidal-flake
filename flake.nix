{
  description = "A Tidal Cycles project. https://tidalcycles.org/";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    tidal = {
      # url = "github:mitchmindtree/tidalcycles.nix";
      url = "github:zmrocze/tidalcycles.nix?ref=karol/superdirt-install";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    my-lib.url = "github:zmrocze/nix-lib";
  };

  outputs = inputs@{ self, nixpkgs, tidal, flake-parts, my-lib, ... }:
    let
      systems = [ "x86_64-linux" ];
      perSystem = nixpkgs.lib.genAttrs systems;
      mkNixpkgsFor = system: import nixpkgs {
        # overlays = nixpkgs.lib.attrValues self.overlays;
        inherit system;
        overlays = [ tidal.overlays.tidal ];
      };
      allNixpkgs = perSystem mkNixpkgsFor;

      nixpkgsFor = system: allNixpkgs.${system};
      myLibFor = system: my-lib.lib (nixpkgsFor system);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;
      perSystem = { pkgs, system, ... }: let 
        pkgs = nixpkgsFor system;
        myLib = myLibFor system;
        my-superdirt-start = pkgs.writeShellApplication {
          name = "my-superdirt-start";
          runtimeInputs = [
            tidal.packages.${system}.sclang-with-superdirt
          ];
          text = ''
            sclang-with-superdirt ${./startup.scd}
          '';
        };
        haskell = pkgs.haskellPackages.developPackage {
          root = ./.;
        };
        
      in {
        _module.args.pkgs = nixpkgsFor system;
        devShells = {
          tidal =  myLib.mergeShells 
              tidal.devShells.${system}.tidal
              (pkgs.mkShell {
                inputsFrom = [ haskell ];
                packages = [ my-superdirt-start ];
              });
          default = self.devShells.${system}.tidal;
        };
        formatter = tidal.formatter.${system};
      };
    };
}