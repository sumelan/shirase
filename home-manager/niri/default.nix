{ pkgs, ... }:
{
  imports = [
    ./binds.nix
    ./idle.nix
    ./lock.nix
    ./rules.nix
    ./settings.nix
  ];

  home = {
    packages = with pkgs; [
      seatd
      jaq
    ];
  };
}
