_: {
  flake.modules.nixos.core = {user, ...}: {
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://vellum.cachix.org"
      ];

      trusted-users = [user];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vellum.cachix.org-1:gUB2bSe5JrLoUCOhwM/VwiIKJBwRTBQ5HVhCLaw9vKk="
      ];

      extra-substituters = [];

      extra-trusted-public-keys = [];
    };
  };
}
