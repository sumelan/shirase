_: {
  flake.modules.nixos."hosts/acer" = {
    config,
    user,
    ...
  }: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = {
          idle = {
            behavior_order = ["lock" "screen-off" "lock-and-suspend"];

            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 400.0;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 800.0;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 500.0;
              };
            };
          };
        };
      };
    };
  };
}
