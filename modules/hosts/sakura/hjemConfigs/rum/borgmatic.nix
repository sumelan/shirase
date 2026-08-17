_: {
  flake.modules.nixos."hosts/sakura" = {user, ...}: {
    hjem.users.${user}.rum = {
      programs = {
        borgmatic = {
          enable = true;
          backups = {
            audiobookshelf = {
              location = {
                sourceDirectories = ["/persist/var/lib/audiobookshelf"];
                repositories = [
                  {
                    label = "borgbase";
                    path = "ssh://f8kl5bwg@f8kl5bwg.repo.borgbase.com/./repo";
                  }
                ];
              };

              consistency.checks = [
                {
                  name = "repository";
                  frequency = "2 weeks";
                }
                {
                  name = "archives";
                  frequency = "4 weeks";
                }
                {
                  name = "data";
                  frequency = "6 weeks";
                }
                {
                  name = "extract";
                  frequency = "6 weeks";
                }
              ];

              retention = {
                keepDaily = 7;
                keepWeekly = 4;
                keepMonthly = 6;
              };

              storage = {
                extraConfig = {
                  ssh_command = "ssh -i ~/.ssh/borgbase";
                };
              };
            };
          };
        };
      };

      services.borgmatic = {
        enable = false;
        frequency = "hourly";
      };
    };
  };
}
