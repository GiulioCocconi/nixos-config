{ lib, options, config, pkgs, ...}:
with lib;

let
   cfg = config.cogisys.suites.scientificWriting;
   gui = config.cogisys.system.gui;
in
{
  options.cogisys.suites.scientificWriting = with types; {
    enable = mkBoolOpt false "Enable scientific writing suite.";
  };

  config = mkIf cfg.enable {

  assertions = [{
    assertion = (gui.enable == true);
	message = "gui system module must be enabled in order to do scientific writing!";
  }];

  environment.systemPackages = [
    pkgs.tetex
	pkgs.asymptote
	pkgs.sage
	pkgs.inkscape
    #config.nur.repos.rewine.mogan
  ];

  };
}
