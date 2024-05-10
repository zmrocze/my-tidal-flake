{
  description = "A Tidal Cycles project. https://tidalcycles.org/";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    tidal = {
      # url = "github:mitchmindtree/tidalcycles.nix";
      url = "github:zmrocze/tidalcycles.nix?ref=karol/superdirt-install";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ tidal, self, ... }:
    let
      pkgsFor = system: import inputs.nixpkgs {
        system = system;
        overlays = [ tidal.overlays.tidal ];
      };
    in 
    tidal.utils.eachSupportedSystem (system: {
      devShells = {
        tidal = tidal.devShells.${system}.tidal;
        default = self.devShells.${system}.tidal;
      };
      formatter = inputs.tidal.formatter.${system};
    });
}
