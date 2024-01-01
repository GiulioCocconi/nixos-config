{config, options, lib, pkgs, inputs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.emacs;
  
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

  # TODO: Use the org file as SSOT, avoid using configDir. The config
  #       should be generated *ONLY* from the org file when the flake
  #       downloads emacs-config input.
  
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
