{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./binds.nix
    ./rules.nix
  ];

  home = {
    packages = with pkgs; [
      seatd
      jaq
    ];
  };
}
