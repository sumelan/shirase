{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.nix-secrets = {
    config,
    user,
    ...
  }: {
    security.nix-secrets = {
      enable = true;
      storage = inputs.my-secrets + "/storage";
      identityPaths = [
        "/persist/home/${user}/.age/nix-secrets"
      ];
      recipientAliases = {
        sakura = "age174vzcjf6vde4sm57cvyrraxmtqs57e5f26useyt9kl46ah5zr3qs3hry66";
        minibookx = "age13fmxvm9r7kvzjwf0u26pnka6jfd8naappkqtzzwnn96dx305sasshefcew";
        omen = "age18340tvr5745jtys29mycpxpakmmfj0jd6z8tq5t20k5ftqfz6s0qmw9klj";
      };
      defaultRecipients = ["sakura" "minibookx" "omen"];
      templates = {
        "access-tokens.conf" = {
          mode = "0660";
          owner = user;
          group = "users";
          content = ''
            access-tokens = github.com=${config.security.nix-secrets.secrets."access-tokens/github"}
          '';
        };
      };
      secrets =
        {
          "access-tokens/github" = {
            mode = "0660";
            owner = user;
            group = "users";
          };
        }
        // (lib.optionalAttrs config.services.syncthing.enable {
          "syncthing/gui-password" = {
            mode = "0440";
            owner = config.services.syncthing.user;
            inherit (config.services.syncthing) group;
          };
        });
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".age"
      ];
    };
  };
}
