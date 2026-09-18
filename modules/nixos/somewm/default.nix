# Copyright (c) 2026 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, cogisysLib, config, options, pkgs, inputs, ... }:
with lib;
with cogisysLib;

let
  cfg = config.cogisys.somewm;
  gui = config.cogisys.system.gui;

  configPath = inputs.awesome-config.outPath;


  luaModules = with pkgs.luajitPackages; [
    luarocks
    luautf8
  ];

  somewm = pkgs.somewm.override {
    extraLuaPackages = _: luaModules;
  };

  configFlags = configPath: "--search ${configPath} -c ${configPath}/rc.lua";

  mkSomeWMSession = n: extraArgs:
    (pkgs.writeTextDir "share/wayland-sessions/${n}.desktop" ''
      [Desktop Entry]
      Name=${n}
      Comment=somewm Wayland session
      Exec=${pkgs.dbus}/bin/dbus-run-session ${somewm}/bin/somewm ${extraArgs}
      Type=Application
      DesktopNames=${n}
    '').overrideAttrs (_: {
      passthru.providedSessions = [ n ];
    });

in
{
  options.cogisys.somewm = with types; {
    enable = mkBoolOpt false "Enable somewm.";
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkAssertionModule gui "GUI" "somewm")
      (mkAssertion (builtins.pathExists configPath)
        "Awesome config file (${configPath}) does not exists")
    ];

    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.acpid.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
    ];

    environment.systemPackages = [
      pkgs.rofi
      pkgs.udiskie
      pkgs.picom
      pkgs.libnotify
      pkgs.slurp
      pkgs.grim
      pkgs.wl-clipboard
      somewm
    ];


    services.xserver.updateDbusEnvironment = true;

    xdg.portal.enable = true;
    xdg.portal.wlr.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];

    services.displayManager.sessionPackages = [
      (mkSomeWMSession "somewm" (configFlags configPath))
      (mkSomeWMSession "somewm-debug" (configFlags "/home/giulio/awesomewm"))
    ];
  };
}
