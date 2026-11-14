_: {
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://niri-nix.cachix.org"
    ];

    trusted-users = ["sumelan"];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
    ];

    extra-substituters = [
      "https://sonora.cachix.org"
    ];

    extra-trusted-public-keys = [
      "sonora.cachix.org-1:qbPeDsvZPbwUWHpQS5Oe0bjz5oHAVscHem+MCzwrc9Q="
    ];
  };
}
