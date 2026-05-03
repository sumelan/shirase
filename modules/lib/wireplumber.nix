_: {
  flake.custom.functions.wireplumber = _: {
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
