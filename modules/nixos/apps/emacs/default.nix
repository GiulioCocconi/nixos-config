{config, options, lib, pkgs, inputs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.emacs;

  # The ORG file in emacs-config input is the SSOT, the config
  # is generated from that file using `configDrv`

  configDrv = pkgs.stdenv.mkDerivation {
    name = "cemacs-config";
    src = inputs.emacs-config.outPath;
    buildInputs = [ pkgs.emacs ];
    buildPhase = "emacs --batch -l org config.org -f org-babel-tangle";
    installPhase = "cp -r emacs.d $out";
  };

  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;
    config = "${configDrv.outPath}/init.el";
    defaultInitFile = false;
    alwaysEnsure = true;
  };
in
{
  options.cogisys.apps.emacs = with types; {
    enable = mkEnableOption "emacs";
  };


  config = mkIf cfg.enable {

    environment.systemPackages = [
      # Emacs >= 29.1 required!
      (pkgs.writeShellScriptBin "cemacs"
        "EMACS_PURE=TRUE ${myEmacs}/bin/emacs --init-directory ${configDrv.outPath} $@")
      myEmacs # Required in order to load impure configs
    ];

    environment.variables.NIX_EMACS = "TRUE";
  };
}
