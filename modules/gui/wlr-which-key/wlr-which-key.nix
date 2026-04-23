{self, ...}: let
  baseWlrConf = import ./_config.nix {};
in {
  flake.wrappers.wlr-which-key = {wlib, ...}: {
    imports = [wlib.wrapperModules.wlr-which-key];

    initialKeys = "";
    settings = baseWlrConf;
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    nixpkgs.overlays = [
      (_: prev: {
        wlr-which-key = self.wrappers.wlr-which-key.wrap {
          pkgs = prev;
          settings = {
            font = config.custom.fonts.monospace + " 14";
          };
        };
      })
    ];

    hj.packages = [
      pkgs.wlr-which-key # overlay-ed above
    ];

    custom.programs.print-config = let
      confPath = pkgs.wlr-which-key.configuration.constructFiles.cfg.outPath;
    in {
      wlr-which-key =
        # sh
        ''moor --lang yaml ${confPath}'';
    };
  };
}
