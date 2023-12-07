{config, options, lib, pkgs, inputs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.emacs;

  configDir = "${inputs.emacs-config.outPath}/emacs.d";
  
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;
    config = "${configDir}/init.el";
    defaultInitFile = false;
    alwaysEnsure = true;
  };
in
{
  options.cogisys.apps.emacs = with types; {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {

    assertions = [(mkAssertion (builtins.pathExists configDir)
      "Emacs config dir (${configDir}) couldn't be found")];

    # TODO: Avoid using /etc/emacs.d/. You should use the input dir
    # (change also is-pure-nix check in the org file)

    environment.systemPackages = [
      # Emacs >= 29.1 required!
      (pkgs.writeShellScriptBin "cemacs"
        "EMACS_PURE=TRUE ${myEmacs}/bin/emacs --init-directory ${configDir} $@")
    ];

    environment.variables.NIX_EMACS = "TRUE";
  };
}
