{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.system.gui;
  locale = config.cogisys.system.locale;
  virtualmachine = config.cogisys.virtualmachine;
  light = config.cogisys.light;
  my_terminal = if light.memory then pkgs.st else pkgs.kitty;
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
        my_terminal
        zathura
        chromium
      ] ++ optionals (!virtualmachine.enable) [
        mpv
        libreoffice-fresh
        flameshot
      ];

      # TODO: Manage gtk settings without home-manager

      environment.shellAliases.open = "xdg-open";
      environment.variables.TERMINAL = my_terminal.pname;


    };
  }
