_: {
  flake.lib = {
    # rename audio device
    # run`wpctl status` and `wpctl inspect xx`
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
