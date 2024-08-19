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
  configFile = "${configPath}/rc.lua";

  configFlags = "--search ${configPath} -c ${configFile}";

  luaModules = with pkgs.luajitPackages; [
    luarocks
    luautf8
  ];

in
{
  options.cogisys.awesome = with types; {
    enable = mkBoolOpt false "Enable awesomewm.";
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkAssertionModule gui "GUI" "awesomewm")
      (mkAssertion (builtins.pathExists configFile)
        "Awesome config file (${configFile}) does not exists")
    ];

    services.displayManager.sddm.enable = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];

    environment.systemPackages = with pkgs; [
      rofi
      udiskie
      picom
      libnotify
      awesome
    ];

    services.xserver.updateDbusEnvironment = true;
	services.acpid.enabled = true;

    services.xserver.windowManager.session = singleton
      { name = "awesome";
        start =
          ''
            ${pkgs.awesome}/bin/awesome ${makeSearchPath luaModules} ${configFlags} &
            waitPID=$!
          '';
      };
  };
}
