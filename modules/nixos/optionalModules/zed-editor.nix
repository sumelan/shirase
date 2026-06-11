_: {
  flake.modules.nixos.zed-editor = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user}.packages = [
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
