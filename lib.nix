{ lib, pkgs, ... }:
lib.extend (
  _: libprev: {
    # namespace for custom functions
    custom = rec {
      # writeShellApplication with support for completions
      writeShellApplicationCompletions =
        {
          name,
          bashCompletion ? null,
          zshCompletion ? null,
          fishCompletion ? null,
          ...
        }@shellArgs:
        let
          inherit (pkgs) writeShellApplication writeTextFile symlinkJoin;
          # get the needed arguments for writeShellApplication
          app = writeShellApplication (lib.intersectAttrs (lib.functionArgs writeShellApplication) shellArgs);
          completions =
            lib.optional (bashCompletion != null) (writeTextFile {
              name = "${name}.bash";
              destination = "/share/bash-completion/completions/${name}.bash";
              text = bashCompletion;
            })
            ++ lib.optional (zshCompletion != null) (writeTextFile {
              name = "${name}.zsh";
              destination = "/share/zsh/site-functions/_${name}";
              text = zshCompletion;
            })
            ++ lib.optional (fishCompletion != null) (writeTextFile {
              name = "${name}.fish";
              destination = "/share/fish/vendor_completions.d/${name}.fish";
              text = fishCompletion;
            });
        in
        if lib.length completions == 0 then
          app
        else
          symlinkJoin {
            inherit name;
            inherit (app) meta;
            paths = [ app ] ++ completions;
          };

      # produces an attrset shell package with completions from either a string / writeShellApplication attrset / package
      mkShellPackages = lib.mapAttrs (
        name: value:
        if lib.isString value then
          pkgs.writeShellApplication {
            inherit name;
            text = value;
          }
        # packages
        else if lib.isDerivation value then
          value
        # attrs to pass to writeShellApplication
        else
          writeShellApplicationCompletions (value // { inherit name; })
      );

      # produces ini format strings, takes a single argument of the object
      toQuotedINI = libprev.generators.toINI {
        mkKeyValue = libprev.flip libprev.generators.mkKeyValueDefault "=" {
          mkValueString =
            v: if libprev.isString v then "\"${v}\"" else libprev.generators.mkValueStringDefault { } v;
        };
      };
    };
  }
)
