{pkgs}: let
  inherit (pkgs.lib) concatStringsSep;
in {
  shell-integration-features = "sudo";
  alpha-blending = "linear-corrected";
  app-notifications = "no-clipboard-copy";
  background-opacity = 1.0;
  confirm-close-surface = false;
  copy-on-select = "clipboard";
  cursor-style = "block";
  cursor-opacity = "0.6";
  adjust-cursor-thickness = 4;
  cursor-style-blink = true;
  font-family = "Maple Mono NF";
  font-size = 14;
  window-decoration = "none";

  shell-integration = "nushell";
  theme = "Catppuccin Frappe";
  font-feature = concatStringsSep "," [
    "+calt" # default ligatures
    "+zero" # alternate zero
    "+cv62" # alternative question
    "+cv63" # alternative left arrow
    "+cv66" # alternative pipe arrows
    "+ss03" # arbitary tag
    "+ss05" # thin escape backslash
    "+ss07" # relax multi-greaters condition
    "+ss08" # double / back rows
    "+ss09" # alternative not equal
    "+ss10" # aaproximately equal
    "+ss11" # extra equal ligatures
  ];
}
