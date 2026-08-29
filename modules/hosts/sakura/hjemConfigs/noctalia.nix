_: {
  flake.modules.nixos."hosts/sakura" = {user, ...}: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = {
          idle = {
            behavior_order = ["lock" "screen-off" "lock-and-suspend"];

            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 600.0;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = false;
                timeout = 900.0;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 720.0;
              };
            };
          };
        };
      };
    };
  };
}
