{ inputs, ... }: {
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
            # withHoogle = true;
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
      # https://numtide.github.io/devshell/modules_schema.html
      devshells.haskell = {
        devshell = {
          name = "Haskell shell";
          motd = ''
            ❄️ Haskell ❄️
          '';
          packagesFrom = [ project.devShell ];
        };
      };
      inherit (project) apps checks packages;
    };

}
