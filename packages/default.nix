{ pkgs, ... }:
{
  fuzzel-scripts = pkgs.callPackage ./fuzzel-scripts { };

  niricast = pkgs.callPackage ./niricast { };
}
