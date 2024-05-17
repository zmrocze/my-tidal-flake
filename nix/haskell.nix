{ inputs, config, ... }: {
  pkgsConfig.overlays = [
    inputs.haskellNix.overlay
    (final: _: {
      haskellProject =
        final.haskell-nix.project' {
          src = ../.;
          evalSystem = "x86_64-linux";
          compiler-nix-name = "ghc928";
          shell = {
            exactDeps = true;
            withHoogle = true;
            # packages = ps: with ps; [];
            tools = {
              # cabal = "3.6.2.0";
              cabal = { };
              haskell-language-server = "2.7.0.0";
            };
          };
        };
    })
  ];
  perSystem = { pkgs, ... }:
    let
      project = pkgs.haskellProject.flake { };
    in
    {
      inherit (project) checks apps packages;
      devShells.haskell = project.devShell;
    };

}
