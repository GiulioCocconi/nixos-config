{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.system.gui;
  locale = config.cogisys.system.locale;
  virtualmachine = config.cogisys.virtualmachine;
in
  {
    options.cogisys.system.gui = with types; {
      enable = mkBoolOpt false "Enable gui.";
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
        gnome.adwaita-icon-theme
        st
        zathura
        chromium
      ] ++ optionals (!virtualmachine.enable) [
        mpv
        libreoffice-fresh
        flameshot
      ];

      # TODO: Manage gtk settings without home-manager

      environment.shellAliases.open = "xdg-open";

    };
  }
