{pkgs, ...}: rec {
  attrs = lhs: rhs:
    lhs
    // rhs
    // (builtins.mapAttrs (
        rName: rValue: let
          lValue = lhs.${rName} or null;
        in
          if builtins.isAttrs lValue && builtins.isAttrs rValue
          then attrs lValue rValue
          else if builtins.isList lValue && builtins.isList rValue
          then lValue ++ rValue
          else rValue
      )
      rhs);

  attrsList = attrsets: pkgs.lib.foldl' attrs {} attrsets;
}
