# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, config, options, pkgs, inputs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.awesome;
  gui = config.cogisys.system.gui;

  getLuaPath = luaModuleStore: dir: "${luaModuleStore}/${dir}/lua/${pkgs.awesome.lua.luaversion}";
  makeSearchPath = lib.concatMapStrings (modulePath:
    " --search " + (getLuaPath modulePath "share") +
    " --search " + (getLuaPath modulePath "lib")
  );

  configPath = inputs.awesome-config.outPath;


  luaModules = with pkgs.luajitPackages; [
    luarocks
    luautf8
  ];

  configFlags = configPath: "--search ${configPath} -c ${configPath}/rc.lua";

  mkAwesomeSession = n: configPath: {
    name = n;
    start = ''${pkgs.awesome}/bin/awesome ${makeSearchPath luaModules} ${configFlags configPath} &
            waitPID=$!'';
  };


in
{
  options.cogisys.awesome = with types; {
    enable = mkBoolOpt false "Enable awesomewm.";
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkAssertionModule gui "GUI" "awesomewm")
      (mkAssertion (builtins.pathExists configPath)
        "Awesome config file (${configPath}) does not exists")
    ];

    services.displayManager.sddm.enable = true;
    services.acpid.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
    ];

    environment.systemPackages = with pkgs; [
      rofi
      udiskie
      picom
      libnotify
      awesome
    ];

    services.xserver.updateDbusEnvironment = true;

    services.xserver.windowManager.session = [
      (mkAwesomeSession "Awesome" configPath)
      (mkAwesomeSession "awesome-debug" "/home/giulio/awesomewm")
    ];
  };
}
