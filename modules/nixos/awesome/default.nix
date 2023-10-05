{ lib, config, options, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.awesome;
  gui = config.cogisys.system.gui;
in
  {
    options.cogisys.awesome = with types; {
      enable = mkBoolOpt false "Enable awesomewm.";
    };

    config = mkIf cfg.enable {
      assertions = [(mkAssertionModule gui "GUI" "awesomewm")];

      services.xserver.displayManager.sddm.enable = true;
      environment.systemPackages = with pkgs; [
        rofi
        udiskie
        picom
        libnotify
      ];

      services.xserver.windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luajitPackages; [
          luarocks
          luautf8
        ];
      };
    };
  }