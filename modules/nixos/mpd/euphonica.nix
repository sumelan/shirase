_: {
  flake.modules.nixos.euphonica = {pkgs, ...}: {
    hj.packages = [
      pkgs.euphonica
    ];

    custom.fileSystem = {
      persist.home.directories = [
        ".cache/euphonica"
      ];
    };
  };
}
