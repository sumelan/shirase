_: {
  flake.custom.hjemConfigs.noctalia = _: {
    custom.fileSystem = {
      cache.home.directories = [
        ".cache/noctalia"
        ".local/state/noctalia"
      ];
    };
  };
}
