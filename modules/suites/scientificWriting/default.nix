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

      environment.systemPackages = with pkgs; [
        (texlive.combine {
          inherit (texlive) scheme-tetex
          dvisvgm;
        })
        asymptote
        sage
        inkscape
        texmacs
      ];

    };
  }
