{ lib, config, options, pkgs, inputs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.awesome;
  gui = config.cogisys.system.gui;

  getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.awesome.lua.luaversion}";
  makeSearchPath = lib.concatMapStrings (path:
    " --search " + (getLuaPath path "share") +
    " --search " + (getLuaPath path "lib")
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

    services.xserver.displayManager.sddm.enable = true;
    environment.systemPackages = with pkgs; [
      rofi
      udiskie
      picom
      libnotify
      awesome
    ];

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
