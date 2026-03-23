{lib, ...}: let
  inherit (builtins) mapAttrs isAttrs isList;
  inherit (lib) foldl';
in {
  flake.lib = rec {
    # rename audio device
    # run`wpctl status` and `wpctl inspect xx`
    wireplumber.rename = old: update: {
      "monitor.alsa.rules" = [
        {
          matches = [{"node.name" = old;}];
          actions = {
            update-props = {
              "node.description" = update;
            };
          };
        }
      ];
    };

    # https://discourse.nixos.org/t/nix-function-to-merge-attributes-records-recursively-and-concatenate-arrays/2030/9
    recursiveMergeAttrs = lhs: rhs:
      lhs
      // rhs
      // (mapAttrs (
          rName: rValue: let
            lValue = lhs.${rName} or null;
          in
            if isAttrs lValue && isAttrs rValue
            then recursiveMergeAttrs lValue rValue
            else if isList lValue && isList rValue
            then lValue ++ rValue
            else rValue
        )
        rhs);

    recursiveMergeAttrsList = attrsets: foldl' recursiveMergeAttrs {} attrsets;
  };
}
