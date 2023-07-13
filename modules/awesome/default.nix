{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.awesome;
  gui = config.cogisys.system.gui;
in
{
  options.cogisys.awesome = with types; {
    enable = mkBoolOpt false "Enable awesomewm.";
  };

  config = mkIf cfg.enable {
    assertions = [{
	  assertion = gui.enable;
	  message = "In order to use awesomewm you have to enable the gui.";
	}];

    services.xserver.displayManager.sddm.enable = true;
	environment.systemPackages = with pkgs; [
	  rofi
	  udiskie
	  picom
	];

    services.xserver.windowManager.awesome = {
	  enable = true;
	  luaModules = with pkgs.luaPackages; [
	    luarocks
		luautf8
	  ];
	};
  };
}
