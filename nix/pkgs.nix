{ inputs, ... }: {
  imports = [ inputs.my-lib.flakeModules.pkgs ];
  pkgsConfig.overlays = [ 
    inputs.tidal.overlays.tidal
    (final: prev: {
      # overwrites what tidal overlay uses to define everything (hey, actually it was completely unneeded given i also overwrite tidal -_-)
      ghcWithTidal = final.haskellProject.ghcWithPackages (_: [final.haskellProject.hsPkgs.zmrocze-tidal]);
      tidal = final.writeShellApplication {
        name = "tidal";
        text = ''
          ${final.ghcWithTidal}/bin/ghci -ghci-script ${../app/BootTidal.hs}
        '';
      };
      supercollider-start = final.writeShellApplication {
        name = "supercollider-start";
        runtimeInputs = [
          final.sclang-with-superdirt
        ];
        text = ''
          sclang-with-superdirt ${../startup.scd}
        '';
      };
    })
  ];

  perSystem = { pkgs, config, ... }: {
    packages = {
      inherit (pkgs) tidal my-superdirt-start;
    };
    apps = {
      tidal = {
        type = "app";
        program = config.packages.tidal;
      };
      superdirt-start = {
        type = "app";
        program = config.packages.my-superdirt-start;
      };
    };
  };
}