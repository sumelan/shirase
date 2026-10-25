{
  description = "Shirase: sumelan's nixos configuration";

  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };
  in {
    packages = import ./outputs/packages.nix {inherit self inputs;};
    nixosConfigurations = import ./outputs/nixosConfigurations.nix {inherit self inputs;};
  };
}
