{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.awesome;
  gui = config.cogisys.system.gui;
in
  {
    options.cogisys.awesome = with types; {
      enable = mkEnableOption "awesomewm";
    };

    config = mkIf cfg.enable {
      assertions = [(mkAssertionModule gui "GUI" "awesomewm")];

      services.xserver.displayManager.sddm.enable = true;
      environment.systemPackages = with pkgs; [
        rofi
        udiskie
        picom
      ];

      services.xserver.windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
          luautf8
        ];
      };
    };
  }
