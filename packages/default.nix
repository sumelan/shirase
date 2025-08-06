{pkgs, ...}: {
  everforest-cursors = pkgs.callPackage ./everforest-cursors {};
  qobuz-player = pkgs.callPackage ./qobuz-player {};
  qogir-cursors = pkgs.callPackage ./qogir-cursors {};
}
