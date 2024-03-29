{ lib, config, options, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.system.gui;
  locale = config.cogisys.system.locale;
  virtualmachine = config.cogisys.virtualmachine;
  networking = config.cogisys.system.networking;
in
  {
    options.cogisys.system.gui = with types; {
      enable = mkBoolOpt false "Enable gui.";
    };

    config = mkIf cfg.enable {

      cogisys.apps.chromium = enabled;
      cogisys.tools.terminal = enabled;

      services.xserver = {
        enable = true;
        xkb.layout = locale.keyboardLayout;
      };

      fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Iosevka" ]; })
      ];

      environment.systemPackages = with pkgs; [
        gnome.adwaita-icon-theme
        chromium
      ] ++ optionals (!virtualmachine.enable) [
        mpv
        evince
        qpdf
        libreoffice-fresh
        gnome.nautilus
        mate.eom
        flameshot
      ] ++ optionals (!virtualmachine.enable && networking.enable) [
        element-desktop
        filezilla
        thunderbird
        # nyxt
      ];

      qt.style = "adwaita-dark";

      # TODO: Manage gtk settings without home-manager
      #       (https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk.nix)

      environment.shellAliases.open = "xdg-open";
    };
  }
