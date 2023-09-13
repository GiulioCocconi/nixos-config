{config, options, lib, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.emacs;
in
  {
    options.cogisys.emacs = with types; {
      enable = mkEnableOption "emacs";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.emacsWithPackagesFromUsePackage {
          config = ./config/emacs.el;
          defaultInitFile = true;
          alwaysEnsure = true;
        })
      ];
      environment.variables.EMACS_NIX = "TRUE";
    };
  }
