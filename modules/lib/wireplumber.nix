_: {
  flake.custom.lib.wireplumber = _: {
    # to obtain interface name, use command `wpctl status`
    # to find the ID of target interfaces. Then, run `wpctl inspect ID` to get the a needed property.
    rename = {
      old,
      new,
    }: {
      "monitor.alsa.rules" = [
        {
          matches = [{"node.name" = old;}];
          actions = {
            update-props = {
              "node.description" = new;
            };
          };
        }
      ];
    };
  };
}
