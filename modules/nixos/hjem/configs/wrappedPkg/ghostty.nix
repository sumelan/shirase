{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) concatStringsSep mkDefault;
in {
  hjem.users.sumelan.rum = {
    programs.ghostty = let
      extraConfig = {
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
      };
    in {
      enable = mkDefault true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty.override {inherit extraConfig;};
      systemd.enable = true;
    };
  };

  environment.sessionVariables = {
    TERMINAL = "ghostty";
  };
}
