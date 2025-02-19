# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, config, options, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.system.gui;
  locale = config.cogisys.system.locale;
  virtualmachine = config.cogisys.virtualmachine;
  networking = config.cogisys.system.networking;
  gtkConfigFile = "gtk-4.0/settings.ini";

  custom-theme = pkgs.stdenvNoCC.mkDerivation rec {
    name = "custom-theme";
    src = ./default-theme;
    propagatedBuildInputs = with pkgs; [
      cogisys.breezeCursor
      adwaita-icon-theme
    ];
    installPhase = "mkdir -p $out/share/icons/default && cp * $out/share/icons/default";
  };
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
      excludePackages = [ pkgs.xterm ];
    };


    services.autorandr.enable = true;

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
    ];

    environment.systemPackages = with pkgs; [
      custom-theme
      adwaita-icon-theme
      chromium
    ] ++ optionals (!virtualmachine.enable) [
      mpv
      evince
      qpdf
      libreoffice-fresh
      nautilus
      mate.eom
      flameshot
      arandr
    ] ++ optionals (!virtualmachine.enable && networking.enable) [
      filezilla
      thunderbird
    ];

    qt.style = "adwaita-dark";


    environment.variables = {
      # XCURSOR_PATH = "$XCURSOR_PATH\${XCURSOR_PATH:+:}"
      #               + "${breeze-cursor.outPath}/share/icons";
      XCURSOR_THEME = "Breeze";

    };

    environment.etc.${gtkConfigFile}.text = ''
      [settings]
      gtk-application-prefer-dark-theme=true
      gtk-theme-name=Adwaita
      gtk-icon-theme-name=Adwaita
      gtk-font-name=Sans 10
      gtk-cursor-theme-name=Breeze
      gtk-cursor-theme-size=0
      gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=0
      gtk-menu-images=0
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintmedium
      gtk-xft-rgba=none
    '';
    environment.shellAliases.open = "xdg-open";
  };
}
