_: {
  flake.modules.nixos.core = {user, ...}: {
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-users = [user];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      extra-substituters = [];

      extra-trusted-public-keys = [];
    };
  };
}
