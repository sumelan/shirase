{ lib, ... }:
{
  acer = lib.custom.nixos.mkSystem "acer" {
    user = "sumelan";
    hardware = "laptop";
  };
  sakura = lib.custom.nixos.mkSystem "sakura" {
    user = "sumelan";
    hardware = "desktop";
  };
}
