{pkgs, ...}: {
  colloid-pastel-cursors = pkgs.callPackage ./colloid-pastel-cursors {};
  colloid-pastel-icons = pkgs.callPackage ./colloid-pastel-icons {};
  qobuz-player = pkgs.callPackage ./qobuz-player {};
}
