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
        sakura = "age12wcqk2g2scuvn4ue6x7kcgs4amr6xmr49f879t4vjzkumyugp9rsjzyyvu";
        minibookx = "age1hswge3466v3f8c42e0jx4337qerd5drcfqkar8f7p89hg04dzuusxh32re";
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
  };
}
