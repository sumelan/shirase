{ lib, pkgs, ... }:
lib.extend (
  _: libprev: {
    # namespace for custom functions
    custom = rec {
      # saner api for iterating through workspaces in a flat list
      # takes a function that accepts the following attrset {workspace, key, monitor}
      mapWorkspaces =
        workspaceFn:
        libprev.concatMap (
          monitor:
          libprev.forEach monitor.workspaces (
            ws:
            let
              workspaceArg = {
                inherit monitor;
                workspace = toString ws;
                key = toString (libprev.mod ws 10);
              };
            in
            workspaceFn workspaceArg
          )
        );
    };
  }
)
