{config, options, lib, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.emacs;
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;

    config = ./emacs.d/init.el;
    defaultInitFile = false;
    alwaysEnsure = true;
  };
in
  {
    options.cogisys.emacs = with types; {
      enable = mkEnableOption "emacs";
    };

    # TODO: Use org config instead!
    config = mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "cemacs" "${myEmacs}/bin/emacs --init-directory /etc/emacs.d $@")
      ];


      environment.etc."emacs.d".source = ./emacs.d;
      environment.shellAliases.emacs = "emacs --init-directory /etc/emacs.d";
      environment.variables.NIX_EMACS = "TRUE";
    };
  }
