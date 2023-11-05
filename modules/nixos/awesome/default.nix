{ lib, config, options, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.awesome;
  gui = config.cogisys.system.gui;

  luaModules = with pkgs.luajitPackages; [
    luarocks
    luautf8
  ];

  getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.awesome.lua.luaversion}";
  makeSearchPath = concatMapStrings (path:
    " --search " + (getLuaPath path "share") +
    " --search " + (getLuaPath path "lib")
  );
  

in
{
  options.cogisys.awesome = with types; {
    enable = mkBoolOpt false "Enable awesomewm.";
  };

  config = mkIf cfg.enable {
    assertions = [(mkAssertionModule gui "GUI" "awesomewm")];

    services.xserver.displayManager.sddm.enable = true;

    environment.etc."awesomewm".source = ./config;
    
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
            ${pkgs.awesome}/bin/awesome ${makeSearchPath luaModules} -c /etc/awesomewm &
            waitPID=$!
          '';
      };  };
}
