{ lib, ... }:
{
  acer = lib.custom.nixos.mkSystem "acer" {
    user = "sumelan";
    hardware = "laptop";
    packages = "unstable";
  };
  sakura = lib.custom.nixos.mkSystem "sakura" {
    user = "sumelan";
    hardware = "desktop";
    packages = "unstable";
  };
}
