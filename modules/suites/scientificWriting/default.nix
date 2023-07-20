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

      assertions = [(mkAssertionModule gui "GUI" "scientific writing")];

      environment.systemPackages = [
        pkgs.tetex
        pkgs.asymptote
        pkgs.sage
        pkgs.inkscape
        pkgs.texmacs
      ];

    };
  }
