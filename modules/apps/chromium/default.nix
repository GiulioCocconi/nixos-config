{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.apps.chromium;
  gui = config.cogisys.system.gui;
  networking = config.cogisys.system.networking;
in
{
  options.cogisys.apps.chromium = with types; {
    enable = mkEnableOption "chromium";
    addNixOSBookmarks = mkBoolOpt true "Add bookmarks related to NixOS.";
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkAssertionModule gui "GUI" "Chromium")
      (mkAssertionModule networking "Networking" "Chromium")
    ];

    programs.chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = 1;
        "BookmarkBarEnabled" = 1;
        "ManagedBookmarks" = [{ toplevel_name = "CoGiSys Bookmarks"; }]
        ++ optionals cfg.addNixOSBookmarks [{
          name = "NixOS";
          children = [
            { name = "NixOS docs"; url = "nixos.org/learn"; }
            { name = "Nixpkgs"; url = "github.com/NixOS/nixpkgs"; }
            { name = "Snowfall"; url = "github.com/snowfallorg"; }
            { name = "NixOS discourse"; url = "discourse.nixos.org"; }
          ];
        }]; # ++ optionals ...
      };
    };


  };
}
