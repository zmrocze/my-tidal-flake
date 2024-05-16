{ inputs, ... }: {
  imports = [ inputs.my-lib.flakeModules.pkgs ];
  pkgsConfig.overlays = [ 
    inputs.tidal.overlays.tidal
    (final: prev: {
      my-superdirt-start = final.writeShellApplication {
        name = "my-superdirt-start";
        runtimeInputs = [
          # tidal.packages.${system}.
          prev.sclang-with-superdirt
        ];
        text = ''
          sclang-with-superdirt ${../startup.scd}
        '';
      };
    })
  ];
}