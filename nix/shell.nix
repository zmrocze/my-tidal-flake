{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    { pkgs
    , config
    , inputs'
    , ...
    }: {
      # https://numtide.github.io/devshell/modules_schema.html
      devshells = {
        default = {
          devshell = {
            name = "Tidal + haskell shell";
            motd = ''
              ❄️ Welcome to the {14}{bold}Tidal{reset} devshell ❄️
              $(type -p menu &>/dev/null && menu)
            '';
            packagesFrom = [
              config.devShells.haskell
            ];
          };
          commands = with pkgs; [
            {
              category = "Tidal";
              name = "tidal";
              help = "Start tidal in ghci";
              package = tidal;
            }
            {
              category = "Tidal";
              name = "ghci'";
              help = "Start ghci, tidal in scope.";
              command = "ghci";
            }
            {
              category = "Supercollider";
              name = "superdirt-start";
              help = "Start only superdirt";
              package = superdirt-start;
            }
            {
              category = "Supercollider";
              name = "supercollider-start";
              help = "Start superdirt and initialize midi";
              package = supercollider-start;
            }
            {
              category = "Supercollider";
              name = "Sclang";
              help = "Start supercollider interpreter, superdirt in scope";
              package = sclang-with-superdirt;
            }
          ];
        };
      };
    };
}
