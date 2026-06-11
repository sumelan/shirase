_: {
  flake.modules.nixos.zed-editor = {pkgs, ...}: {
    hj.packages = [
      pkgs.zed-editor
    ];

    custom.fileSystem = {
      persist.home.directories = [
        ".cache/zed"
        ".config/zed"
        ".local/share/zed"
      ];
    };
  };
}
