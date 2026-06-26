{
  description = "Shirase: sumelan's nixos configuration";

  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };

    inherit (inputs.nixpkgs.lib) hasPrefix lists;
    inherit (inputs.nixpkgs.lib.fileset) toList fileFilter;

    # Replacement for import-tree
    # This recursively collects all nix files that do not start with `_`
    mkImport = path: toList (fileFilter (f: f.hasExt "nix" && !(hasPrefix "_" f.name)) path);
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs self;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = lists.flatten [
        inputs.flake-parts.flakeModules.modules
        (mkImport ./modules)
        (mkImport ./packages)
      ];
      debug = true;
    };
}
