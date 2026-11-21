{
  inputs,
  pkgs,
  customLib,
  ...
}: let
  inherit (customLib.niri) hotkey;
in {
  programs.chromium = {
    enable = true;
    extensions = [
      # Bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
      # Dark Reader
      "eimadpbcbfnmbkopoojfekhnkhdbieeh"
      # kagi privacy pass
      "mendokngpagmkejfpmeellpppjgbpdaj"
      # kagi search
      "cdglnehniifkbagbbombnjghhcihifij"
      # kagi summarizer
      "dpaefegpjhgeplnkomgbcmmlffkijbgp"
      # kagi translate
      "alblebhaoakdgapamjdifdfnaicpnklm"
      # catppuccin-frappe
      "olhelnoplefjdmncknfphenjclimckaf"
      # SponsorBlock for YouTube - Skip Sponsorships
      "mnjggcdmjocbbbhaepdhchncahnbgone"
      # YouTube Auto HD + FPS
      "fcphghnknhkimeagdglkljinmpbagone"
      # youtube no translation
      "lmkeolibdeeglfglnncmfleojmakecjb"
      # Youtube-shorts block
      "jiaopdjbehhjgokpphdfgmapkobbnmjp"
    ];
  };

  hjem.users.sumelan = {
    packages = [
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Add widevine support, inspired from this comment:
    # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
    xdg = {
      #   config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
      #     {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      #   '';

      mime-apps = let
        value = ["helium.desktop"];
        default-applications = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "x-scheme-handler/unknown"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "text/html"
          ]);
        added-associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "x-scheme-handler/unknown"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "text/html"
          ]);

        removed-associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
            "application/pdf"
          ]);
      in {
        inherit
          default-applications
          added-associations
          removed-associations
          ;
      };
    };
  };

  environment.sessionVariables = {
    DEFAULT_BROWSER = "helium";
    BROWSER = "helium";
  };

  custom = {
    wayland.windowManager.niri = {
      extraBinds = {
        "Mod+B" = {
          _props.hotkey-overlay-title = hotkey {
            color = "#c6d0f5";
            name = "  Helium";
            desc = "Web Browser";
          };
          spawn = ["helium"];
        };
      };

      extraWindow-rule = [
        {
          match = [
            {_props.app-id._raw = ''r#"^chrome-.{32}-Default$"#'';} # helium extension's windows
          ];
          open-floating = true;
        }
        {
          match = [
            {_props.title._raw = ''r#"^Picture-in-Picture$"#'';}
            {_props.title._raw = ''r#"^ピクチャーインピクチャー$"#'';}
            {_props.title._raw = ''r#"^ピクチャー イン ピクチャー$"#'';}
          ];
          default-column-width._children = [
            {proportion = 0.450000;}
          ];
          default-window-height._children = [
            {proportion = 0.450000;}
          ];
          open-floating = true;
          opacity = 1.000000;
        }
      ];
    };

    fileSystem = {
      persist.home.directories = [
        ".config/net.imput.helium"
      ];

      cache.home.directories = [
        ".cache/net.imput.helium"
      ];
    };
  };
}
