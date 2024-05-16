{ inputs, ... }: {
  imports = [
    inputs.pre-commit-hooks.flakeModule # Adds perSystem.pre-commit options
  ];
  perSystem = { config, ... }:
    {
      devShells.dev-pre-commit = config.pre-commit.devShell;
      # devShells.default = config.pre-commit.devShell;

      pre-commit = {
        settings = {

          excludes = [
          ];

          hooks = {
            # nix
            nixpkgs-fmt.enable = true;
            deadnix.enable = true;
            statix.enable = true;

            cabal-fmt.enable = true;
            fourmolu.enable = true;
            hlint.enable = true;
            # stylish-haskell.enable = true; # conflicts with fourmolu
          };
        };
      };
    };
}
