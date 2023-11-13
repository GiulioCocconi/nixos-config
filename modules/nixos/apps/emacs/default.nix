{config, options, lib, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.emacs;

  # TODO: Use flake input in order to host the config in a GH repository.
  configDir = ./emacs.d;
  
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;
    config = "${configDir}/init.el";
    defaultInitFile = false;
    alwaysEnsure = true;
  };
in
{
  options.cogisys.emacs = with types; {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {

    assertions = [(mkAssertion (builtins.pathExists configDir)
      "Emacs config dir (${configDir}) couldn't be found")];
    
    environment.etc."emacs.d".source = configDir;

    environment.systemPackages = [
      myEmacs
      
      # Emacs >= 29.1 required!
      (pkgs.writeShellScriptBin "cemacs"
        "${myEmacs}/bin/emacs --init-directory /etc/emacs.d $@")
    ];

    environment.variables.NIX_EMACS = "TRUE";
  };
}
