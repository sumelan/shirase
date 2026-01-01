{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = (import ../../packages) {inherit inputs pkgs;};
  };
}
