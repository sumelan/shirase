_: {
  flake.lib = {
    # rename audio device
    wireplumber.rename = old: update: {
      "monitor.alsa.rules" = [
        {
          matches = [{"node.name" = old;}];
          actions = {
            update-props = {
              "node.description" = update;
            };
          };
        }
      ];
    };
  };
}
