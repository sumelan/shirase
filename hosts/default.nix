{lib, ...}: let
  inherit (lib.custom.nixos) mkSystem;
in {
  acer = mkSystem "acer" {
    user = "sumelan";
    hardware = "laptop";
  };
  sakura = mkSystem "sakura" {
    user = "sumelan";
    hardware = "server";
  };
}
