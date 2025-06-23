{ pkgs, ... }:
{
  btrfs-scripts = pkgs.callPackage ./btrfs-scripts { };
  fuzzel-scripts = pkgs.callPackage ./fuzzel-scripts { };
  desktop-scripts = pkgs.callPackage ./desktop-scripts { };
}
