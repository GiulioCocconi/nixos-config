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
        layout = locale.keyboardLayout;
      };

      fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Iosevka" ]; })
        (google-fonts.override { fonts = []; })
      ];

      environment.systemPackages = with pkgs; [
        gnome.adwaita-icon-theme
        zathura
        chromium
      ] ++ optionals (!virtualmachine.enable) [
        mpv
        libreoffice-fresh
        flameshot
      ] ++ optionals (networking.enable) [element-desktop];

      qt.style = "adwaita-dark";

      # TODO: Manage gtk settings without home-manager
      #       (https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk.nix)

      environment.shellAliases.open = "xdg-open";
    };
  }
