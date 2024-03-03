{
  description = "A Tidal Cycles project. https://tidalcycles.org/";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    tidal = {
      url = "github:mitchmindtree/tidalcycles.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.tidal.utils.eachSupportedSystem (system: {
      devShells = inputs.tidal.devShells.${system};
      formatter = inputs.tidal.formatter.${system};
    });
}
