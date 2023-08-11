{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.system.gui;
  locale = config.cogisys.system.locale;
  virtualmachine = config.cogisys.virtualmachine;
in
  {
    options.cogisys.system.gui = with types; {
      enable = mkEnableOption "gui";
    };

    config = mkIf cfg.enable {

      cogisys.apps.chromium = enabled;

      services.xserver = {
        enable = true;
        layout = locale.keyboardLayout;
      };

      fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Iosevka" ]; })
      ];

      environment.systemPackages = with pkgs; [
        st
        zathura
        chromium
      ] ++ optionals (!virtualmachine.enable) [
        mpv
        libreoffice-fresh
        flameshot
      ];

      environment.shellAliases.open = "xdg-open";

    };
  }
