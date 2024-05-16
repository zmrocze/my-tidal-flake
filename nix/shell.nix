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
      devshells.default = {
        devshell = {
          name = "Project shell";
          motd = ''
            ❄️ Welcome to the {14}{bold}My nix template{reset} devshell ❄️
            $(type -p menu &>/dev/null && menu)
          '';
          # packagesFrom = [];
          # packages = with pkgs; [
          # ];
        };
        # commands = [
        #   {
        #     category = "Tools";
        #     name = "build-all";
        #     help = "Build all the checks";
        #     command = config.apps.nix-build-all.program;
        #   }
        # ];
        # env = [
        #   {
        #     name = "MY_LD";
        #     value = "bla";
        #     # eval = "$LD_PATH";
        #   };
        # ];
      };
    };
}
